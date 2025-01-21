class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "76b3ac45b203cdb9da254f53f0c3b53d6dfc1d7cce991d1d9280618fe2cea1b7"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca36a98b7886f2de87c6da8bda7ec721234750887d593450e7bbd7fe56baf796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0be4327e4e2fa7d2ac4bd15360070db01b4d5c752bb29c68c36d30cc9bcd37c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5a4a6cf0ab03e30f4d25708683c8637bae4a6ba133c487117af87b37cd43688"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaf5278ca58fad0d529082f019c553d201a6509441f7c5423444a674867d7523"
    sha256 cellar: :any_skip_relocation, ventura:       "255a0ce3be60c4e101a47ae2b4ed7b520b43056d34e889adbe83f44abcfbd9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414188ee0bd4ac192e4add626b41263f55f8b4ad696d32c078fcb4cab6ef98a7"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metals/dependencyClasspath' 2>/dev/null")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    (libexec/"lib").install buildpath.glob("metals/target/scala-*/metals_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"metals").write_env_script "java", args.join(" "), env
  end

  test do
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3(bin/"metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
