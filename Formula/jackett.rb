class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2603.tar.gz"
  sha256 "82326400fdb4ca9e942726c2c432232088e4a468ead9d4712761068e5082cd36"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7ec3961250cc74bdc0067f03a5f47a66bd082145b7ce45cfcdf36f31f1cc30db"
    sha256 cellar: :any,                 arm64_monterey: "ffea8e6137226dc6cdd86c11803b4df09bcaed05dc0e05f58c9f5fecb950030f"
    sha256 cellar: :any,                 arm64_big_sur:  "8a8b37848d4fec73d02b1d6c706aa82608f6f00696df5dc88a714641e81778c0"
    sha256 cellar: :any,                 ventura:        "5e996a418895e7cd31a7d8191a9e3034f9e30c479d8deac72266175ba5337bbc"
    sha256 cellar: :any,                 monterey:       "abcf2f93d45577653145e4fd4fdad873dd28418b113779c37ef0bf50848d44a3"
    sha256 cellar: :any,                 big_sur:        "892478960408806564cac745b7d7210fe78149e14cb86fdf50ef621d09d0730e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ac6707870d05d9a1ed2d9a9c785df32ab0064a225996d36224a23571a35338"
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
