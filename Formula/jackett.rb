class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1270.tar.gz"
  sha256 "460c5b47c8a2198cc4022a65edafe7811801d831a88325f1d99cb72d26e924f2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a30f7e21624262271928401694ab03cb1e6766c0e863f8371ffb72c8e499842"
    sha256 cellar: :any,                 arm64_big_sur:  "15d84889f8bb66fc8201820c02836f05422f38525b79f6060cea25b45d8973aa"
    sha256 cellar: :any,                 monterey:       "74e79e0648090254c4484350a33a2571a9fa6eae01a7bc873250ff2c7bb4a1b9"
    sha256 cellar: :any,                 big_sur:        "c8285fe013c7c5f8a0eb977ea5d352687bd9c590b0e3636048a7b6fc332b3082"
    sha256 cellar: :any,                 catalina:       "a79db76a3d00f244317fd77fe6cae0e4ee1dc13c12a6214b0a7683364ada456a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b25fbbf0edd29b8adfd9071e889e096bc132b66314046b3a74404b71dd9c8f"
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
