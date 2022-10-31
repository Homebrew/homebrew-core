class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2180.tar.gz"
  sha256 "48b2f8dfd12dda36ccf326cfd9e93131fdcf2aff9230cc79473ffde27fd5972d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "864baa942feaa7370c11b3a4af7d20f2aafd3ec4b863864ef3420ad6260a85a6"
    sha256 cellar: :any,                 arm64_big_sur:  "fdbd336b2580f8e40a677bd752ca0949b6765d802a1ee39e11133d9b36bf0142"
    sha256 cellar: :any,                 monterey:       "d5d9fa1e735c9e1050c64207e93577b43ac78f30ddbe1c63deb2bf3d523f942a"
    sha256 cellar: :any,                 big_sur:        "8676822f16e404f9383007f244387f4cf685193b481ab811a0b0961a438d5af1"
    sha256 cellar: :any,                 catalina:       "52fd70707371cd4e6a2c1d6832c4d45ed3ce279f87c76813db52793f3c84dd26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5d3079578ebdc07648d86854d1b765496baf825a7fa9080c41ef1b32c33880"
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
