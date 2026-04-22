class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "a83ab1596997720e83980b781f3d96d2753b7548415606694e15c26e93359445"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1c56a41c01cb722370d5ed47728eeebe4318fcd131576508b97b5800d76b96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dddfe00852a98778dee81b9d97aa4b9fd817165267bd8a862a735f3226c4906f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aff4f194883fd27098cb61d71e816cc69fe94703d6d7c2e5783a53568a30026"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d05dea8e42f7bdff1e84b3a4a3531b33d647e83e5ad5225abee2f24afee9f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65ab4cc07ddd43ec50f098fb6afa9a976c67d0ec875303679dbc4cf849f27def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88940c32e5eb6ac360941dd9db13b4ac0809cdb8aaa9ae2bd4d8606541d07233"
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
