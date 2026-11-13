class JadxHeadlessMcp < Formula
  desc "Headless MCP server for Android APK static analysis"
  homepage "https://github.com/1013503897/jadx-headless-mcp"
  url "https://github.com/1013503897/jadx-headless-mcp/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8a97fcd615b5ec99b9b3a6b459f68599df0baad8283cf094c1db0302ea9acf05"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    inreplace "build.gradle.kts", "    jvmToolchain(17)", <<~KOTLIN
      compilerOptions { jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17) }
      java { targetCompatibility = JavaVersion.VERSION_17 }
    KOTLIN
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/jadx-headless-mcp-#{version}-all.jar"
    bin.write_jar_script libexec/"jadx-headless-mcp-#{version}-all.jar", "jadx-headless-mcp"
  end

  test do
    IO.popen(bin/"jadx-headless-mcp", "r+") do |mcp|
      mcp.puts({
        jsonrpc: "2.0", id: 1, method: "initialize",
        params:  {
          protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "homebrew", version: "1.0" }
        }
      }.to_json)
      assert_match "jadx-headless-mcp", mcp.gets
      mcp.puts '{"jsonrpc":"2.0","method":"notifications/initialized"}'
      mcp.puts '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
      assert_match '"name":"load_apk"', mcp.gets
    ensure
      Process.kill "TERM", mcp.pid
    end
  end
end
