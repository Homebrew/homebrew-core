class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1033.tar.gz"
  sha256 "ba92c4254442b880ca510298f8fa747df4bbe87e5f135616c5590fa4ffe429fd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a97e8d66487b455beb4433435dd5437ced974b118a36d000673f1711e2a9ed50"
    sha256 cellar: :any,                 arm64_monterey: "2f0fa7534cc4d7f5bc6682e39946075c0450452ac9229081730fc2078d1fc150"
    sha256 cellar: :any,                 ventura:        "76f8b71d05f14a24c4d0ab03859f0ebee54a92b3466acd56b1c58bfd3fe7159f"
    sha256 cellar: :any,                 monterey:       "75d9e79604ab9f4e22cb0c9cc03a9a25fcee96a60a69d8bc09c85140db1b01c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b71bc6d6f42a2840679f8ac0df1a3f677f3dd361ab8a50196aa0948a6a00ff7"
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
