class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1843.tar.gz"
  sha256 "e4c2493930ce8c7c22b637797aedad823513d828f54a147b1571d24f811f260c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd3c9f3c52b1dc196de7adab58249b8490b40a10b81ed87bb1a60a337cf2f0b1"
    sha256 cellar: :any,                 arm64_big_sur:  "e2752b3b184941d5b8ea932bb910728406854d13527610c9befb486697679eff"
    sha256 cellar: :any,                 monterey:       "4c9eb24b3e4a3661beeeda49f917d68e3f5d12853c3e7ce3437428ede1dd58fb"
    sha256 cellar: :any,                 big_sur:        "a8f7d26efa393c093ec861f9b7e821c2b163034498730f72a512dd18431f29ce"
    sha256 cellar: :any,                 catalina:       "34c493434304317269057421e3c947373ba29fac8816e71d7617f222f3f293e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e16cf8ab982ac66369f1b42e2793242b79e453c3339f0666684c6a8ea507d2"
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
