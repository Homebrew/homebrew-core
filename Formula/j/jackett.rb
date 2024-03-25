class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2146.tar.gz"
  sha256 "bd0d2f4161efb85395d0c86772fb73da7f28acc4a0b8afa9071790a8a298312d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63c43f2c41c6995d2ba501ae28c52d9b6bc83d866e678ea83cfbab1c75b9df3d"
    sha256 cellar: :any,                 arm64_monterey: "d7b3da9f78623b14dea9709960f24ce42a14ed6782ed64891d61845a62790a72"
    sha256 cellar: :any,                 ventura:        "5d4ca10607b7024d00f3e15d5c02546aa41cee0c6f7955089e944fe9b98616b9"
    sha256 cellar: :any,                 monterey:       "41d5011cbb00a5bddfec0cbb869829ff35afbebb74fb44f383a56c9e07732c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f8f862de2d7a38322825f554ec361aa25e2e5c4588a3a07a0419ee4469fdc8"
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
    working_dir opt_libexec
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
