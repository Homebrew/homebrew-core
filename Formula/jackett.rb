class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3017.tar.gz"
  sha256 "acd1673890edab41d74b957f1e622ee99f94aada8c5fb11d2cf5364b15b703f7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9035e72b86a75b54a4f8db9deb883e79b80afdf27fd59e8a50511d3341737f3"
    sha256 cellar: :any,                 arm64_monterey: "7e6905eef854399c1068aa51fe295077aab3425e7e87211911bbabd2455954f4"
    sha256 cellar: :any,                 arm64_big_sur:  "72a4cd8e87c6e44ee8ef5b209832271e700f19944e2ab4dc007cec9cdb30dfb2"
    sha256 cellar: :any,                 ventura:        "b7bc6f6206e62d27bca0e4bb49e4245bfbb8eeb51d2b31d9d8c72d8b35b44a69"
    sha256 cellar: :any,                 monterey:       "24f337059b27677bb5044278eee1f8e2c226cc675366e2fd5758dc5448121dec"
    sha256 cellar: :any,                 big_sur:        "5b0b24633d48afaa20928e301f0131c1f580dcf1bbbd712c573b588343e1c0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893373b3a90b65709826fb13ac91286a8099d7510eb0c0550dd6fd630e1a9a4c"
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
