class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1821.tar.gz"
  sha256 "0e50f5e41061aa741280ab2fbaf3c2a232cf43ae7471c75c443702c78ad7074a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6ef1b568e4c523b257bc4cd53a0cfeb3ca7691e75acff6cfac1f21c1101e20a9"
    sha256 cellar: :any,                 arm64_big_sur:  "9e2e6695637e5a7bc70946eb1d381ca40b4cfd22ccab1e4591242990283483b7"
    sha256 cellar: :any,                 monterey:       "544c38286b395d7abbb3c253bbd0f950cf0fdb520d61f63d83488b91ff40a62d"
    sha256 cellar: :any,                 big_sur:        "7420c647071ee6b823bc30e9bfef875e05b1abc2143ac0d1932f5b8dadc05d79"
    sha256 cellar: :any,                 catalina:       "cea236082e10b30d8392b5bb0174f5669b8d6fc89ac23a1b9a6795b7cb57b297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d3011fdc44d17c529cd92455a729ca88a2fb81140351367fb38efb53897f0d"
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
