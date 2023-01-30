class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2767.tar.gz"
  sha256 "6436c9b18031f79089a4a7f17017a5a1d8ced15ca1a0ae155e67d74b776ac51e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "320ff03982bba92b67fd2233c9c6f718adbbc0cdad6ec3a6c9cbb894b5bee0be"
    sha256 cellar: :any,                 arm64_monterey: "83f9b474d56a80ac586657f281750dbfd9cc0f2dceb92c39062a3744a6d5b2c9"
    sha256 cellar: :any,                 arm64_big_sur:  "03557e7c132a7c7ce323ca41f2c627654129b23ce28ecf1250436240a2a27420"
    sha256 cellar: :any,                 ventura:        "1e2614bc32813136c4eaaf7791b16bae3c17827e93f55ab4a2af5b57f8644b15"
    sha256 cellar: :any,                 monterey:       "05c4cdb0a5ff93f07f9035551195bae1f47bb1391830ce6b410602a849d528cd"
    sha256 cellar: :any,                 big_sur:        "3604e5bde89e41066904c61fe5225c8693c733604eef624823e07fe03d3d0e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34db4e33cebf2d48e702d7c0a75ad65ed70f789e0e182bc909983117410c8356"
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
