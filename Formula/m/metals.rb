class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c3b3e7af8f1ba10ecb3633d04e7b7a0154dec551fdea1691b88ed6d0d78124ba"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a49da0c7cdbc0d371599703e6c755fecdb35a7aed9437acc94ae747f32263f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632febdf2c5e44c4b85eda6d79fdd8ea39c54f5d5fe2be81d1c1f356a42427b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e891e6acc37161612ea3db08175a56f7899731b9c59b080280b85b855a6091"
    sha256 cellar: :any_skip_relocation, sonoma:         "3850327b1b4c2554830d67f65c8d18259570297afdc6e65aa47645ea909a560e"
    sha256 cellar: :any_skip_relocation, ventura:        "1fdcd1ea78a6e23e65d93ad8e9156b2c836b8189e2d4ccf480058e9e9f3a59c7"
    sha256 cellar: :any_skip_relocation, monterey:       "c5025195fe88d0d0112b92b4352a5498e6a37e6191a8b73f597880dcdf30bf3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38bf8e97c53d3e16a91eeaf310c6e9f0ee7db258799206ac5ada2f195e34a75e"
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
    Open3.popen3("#{bin}/metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
