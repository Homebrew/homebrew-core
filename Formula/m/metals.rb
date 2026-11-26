class Metals < Formula
  desc "Scala language server"
  homepage "https://scalameta.org/metals/"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "31b53eddde4ea6f9ea2fb743c8b83979fcba8c96429a6d3d23390446542bb200"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # scala-lang instead.
  livecheck do
    url "https://index.scala-lang.org/api/v1/projects/scalameta/metals/versions/latest"
    regex(/"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    manifest_sha256 "fe470fabbb36d112b1675d4372debbb8f93f5092e03f5d05bb16ddc96e99ea76"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba81751d320ac4a5f92d529cc837703021d93d8ac7e8c778e796d799c3eee3fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58e9048516d9ad89c944e32e22e7d3a0e9dea70a19a9b8cd705a70c1be0a308b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "739b6a1a7378e23627390c67fb6b6ad36bf984c0ef63a0c0396cfb27e1528b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "178be3f1a15de80e98d1194a6c5b3dece895fe18b6b5a8c2c655fdbfeb777149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6dcb51de888b4ece2d4c618318ea5d25c59bc6b3b0f3a1498ca4625baa78f791"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@25"

  def install
    ENV["CI"] = "TRUE"
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    ENV.prepend_path "PATH", dep("openjdk").opt_bin
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

    args = %W[-cp "#{libexec}/lib/*" scala.meta.metals.Main]
    mcp_args = %W[-cp "#{libexec}/lib/*" scala.meta.metals.McpMain]
    env = Language::Java.overridable_java_home_env("25")
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
