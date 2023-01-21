class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2686.tar.gz"
  sha256 "a81e29ec3c21104cf23473e7ca225ded7bb341fad72818d62f44d9a62dbccb6f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af5b4f396f4fa1de81f86cad540e4013c2288a3eb0bca72abcd1e3ffaf1127ec"
    sha256 cellar: :any,                 arm64_monterey: "477247f1a36e626b263086a171767936824b6b03f1e71cf6a5d45301f73756aa"
    sha256 cellar: :any,                 arm64_big_sur:  "313dff29145cef6e2f791ca45f2dd17fe20fada5d959b263022a151d17c7d44f"
    sha256 cellar: :any,                 ventura:        "7cea6333ac365c7c7d6ff175406127f88f5cb6edd603f0eb4b81ff579e6b0ebe"
    sha256 cellar: :any,                 monterey:       "a7ddbd58ca1752a496ae0900864a4b8bab9b4aff0fdb4e3ca6567579219b08b5"
    sha256 cellar: :any,                 big_sur:        "a5f56add9492ca7a23a0544d618e22d93bfd9c7bb79f5f1110d5f40626479c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7213ddfb4972ac7752a0ef6572d62d8c1967823704158e570431f475c84f22b"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
