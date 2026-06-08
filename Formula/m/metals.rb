class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "a83ab1596997720e83980b781f3d96d2753b7548415606694e15c26e93359445"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # scala-lang instead.
  livecheck do
    url "https://index.scala-lang.org/api/v1/projects/scalameta/metals/versions/latest"
    regex(/"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1150c8b545397175d0eb64eed9e49a62ec12bf033e372416fb6315fa7a136d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab4c66ec63e993ce9ff6a90793fc0adbbb9d830057b82a8c9476583a4ae1ffde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc3d7f509dd0e044656e2082113cfc82cbaad6d7780a392598922db2465b02d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "26de98eab7d29c763fa549c5fa47095a8f7914d081d272a2b64332c9295cde85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e4423559e8c3981a556371e787bc3feca8bb48d6fa8f7cef9d00c2b6d53485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785031b654d0f6735a1ff5428089c6f86765f00952ba2c10ea4ae0ad565bba83"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@25"

  def install
    ENV["CI"] = "TRUE"
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    ENV.prepend_path "PATH", Formula["openjdk@25"].opt_bin
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
