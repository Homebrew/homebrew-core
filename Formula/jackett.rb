class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2097.tar.gz"
  sha256 "e594cc76c0a9e106d47274b4289369442f5fbb4728dbe90e3293b7960f229891"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70f9be4ab24c7d25b80c9f3e02710d942075b16185acc27d50e3aff04eca0a26"
    sha256 cellar: :any,                 arm64_big_sur:  "c9d100a263026513173e034f8e36ba45a10e8df81ab9d2154d964f25276e56b0"
    sha256 cellar: :any,                 monterey:       "d7808a98e2d48da85aa2f944c064666b28df16a5423c79243debb982a59e2df8"
    sha256 cellar: :any,                 big_sur:        "839bca0453b603865ae4576183a8c7f1fb463892a09665d37d9260fda6e28a84"
    sha256 cellar: :any,                 catalina:       "cb7f81d263eb563fd5915466d096bb3cb937228c8feca32f98a652ebfd2c28a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eaaacdd46da353a9045962c51f8cb07e31aef2d045068c47c9e100738f75d82"
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
