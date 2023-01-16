class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2640.tar.gz"
  sha256 "983945b577dea3aa7a1f1811310f1380bbdbf868799feee3d00d8c3265b91fa7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "879e47b8db0cd1b4a037b8b1ef2d0f64cb7b499600eb3589c21612dd60af97a6"
    sha256 cellar: :any,                 arm64_monterey: "5375faac4bb15879a13d274c00802b4d73682703b4b90b234c97216e8ffee1b2"
    sha256 cellar: :any,                 arm64_big_sur:  "9c96e6486ce615906cb4a740f39f23f0a1ca925a2f406c3d55b684b2d901730e"
    sha256 cellar: :any,                 ventura:        "75666edbc589a7e5ebbaff6e1fb57238d21d6cf940a6ee0fb714d604ac948f89"
    sha256 cellar: :any,                 monterey:       "9a3c2e7419b651b88d69947fb21d649fad5089d4b0d6b662a902bac5c3d1f5a9"
    sha256 cellar: :any,                 big_sur:        "af2e9878d15326cdde1bbc84bb727962b2a5fd4fce7776667f3399d83cf6952d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982035510051028f3322e6fc5e061f5ef7434fe42b9a30f9dcac7599ebcd6920"
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
