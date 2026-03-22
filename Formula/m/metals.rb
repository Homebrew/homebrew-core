class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "ea1a52ab1cc808b116623d4e338427143314bf4e8d1eb7f6b17c02fe41f6fd97"
  license "Apache-2.0"
  revision 1

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74ba892101b9d717d10d0d4f7c70652582ef8997988da312fcfdc902a77ecb97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da992b7241db26b81b7cab105a8d030c9533c92e989088e1b77e9f2227448fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0fef690c0a81748fd7237ec44784b75c49c3d7eea169df19082032ce0a05df"
    sha256 cellar: :any_skip_relocation, sonoma:        "955538892db8dd8199423bc4e2ccdc74235c40f6ed68c11f27e4e49994440710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "112eec103a55e747171e7b355a34635ec30467cda950a61605c443e9c029c6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d7d685f20a9532d2fb4e77edf78abd01a95edddadbecf01ce701e3dada6f921"
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
    (libexec/"lib").install buildpath.glob("metals-mcp/target/scala-*/metals-mcp_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    mcp_args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.McpMain]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"metals").write_env_script "java", args.join(" "), env
    (bin/"metals-mcp").write_env_script "java", mcp_args.join(" "), env
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

    assert_match "Error: --workspace is required", shell_output("#{bin}/metals-mcp 2>&1", 1)
  end
end
