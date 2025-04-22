class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "e961a43afa10d386192a4aa018025972166b3dfa046653cb6aa8b2bdcd065594"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec5166dec9f73897a0c2bed54561532f3ba96860cac82786c264f53df7cd015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be3e75ec85f178bae8ae6be53569353cffa880cef21c4ef9f31e72a755ffe83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "760e4cd8a5b0441dded0d6edcdd10fbb65720762ff5a10fff242059811c5350f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2a3b4701d2fd52f4545a89d7bed7e88ac0827ab9d75e3a42892de33a3ed14f"
    sha256 cellar: :any_skip_relocation, ventura:       "2849c6b6df1937e75f052c481b3b74b4d777c2d8557fb0b1b2b9b05b7a8c6f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec136cfc0c576dabe8ed533cc00a537bbc001d4cf8b9747c35a2d22b18caf81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a10bb3b687a1c3207b15c1f9aa2c4efb6ed2c03613c8656d2414e3703487a059"
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
