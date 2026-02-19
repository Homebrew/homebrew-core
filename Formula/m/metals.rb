class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "a6f9b70ae9f46a555549f1b9fe7db60a1e982999c346dad50fa54fb68557bea2"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817df4688e312ca69320964fdca39354046523765ade920d1736328ab6c6483c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6842fd80fa4f8e628dc98908590efa259f71b0c923587e956ebc1bb197dab5c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d99dea8e2dc23ed2854c09f5230ec1041584b336cb918722a4f8bb64dee6ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "08ec20fb03902e3543d8014dbc2c9e84de7f6708d5ae32588fe538b87a19aa1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2424662fb0344cdb1345acd63538a4159a8c6e57b34c2c8ca480c2e0873eeb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87646bbe2b46af016c9989c3d1edeef6e2d193e1672158c16ca3b5d2e01a833e"
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
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |line| line.strip.gsub(dep_pattern, '\1') }
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
