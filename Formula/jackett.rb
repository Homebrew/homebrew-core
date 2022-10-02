class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2041.tar.gz"
  sha256 "c5602ddda0bfb350839519c0e96ae8a71e7fbb1fcf867ec43bfe173823dd13f3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eed806e88c7ba9911ea74c29280a86364c9eed1f0730c4afb831dff8fe3137d8"
    sha256 cellar: :any,                 arm64_big_sur:  "a0d000b1750961d6e518fc30afd28fd7d75d395c75e4746f81d4cfe1426cf4df"
    sha256 cellar: :any,                 monterey:       "0ce1b16950ba986dfc59a20eaa722770e0e058c6d0899f9bc01265afc1cf2e12"
    sha256 cellar: :any,                 big_sur:        "71fb01a7218830e266b091991d1129a6510e983a36529368275a53a9a518eaab"
    sha256 cellar: :any,                 catalina:       "a6be45251a626254a57531bc28af0ce99366cb3c8b6d69dcf394611cd22194a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be2068d612beb8948be11df1b6608fdfa21acb36c79b26e92da66cf52dc00a1"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
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
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
