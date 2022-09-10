class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1861.tar.gz"
  sha256 "c3f69781c9965ddcd3b1d4d5d595cfbdbf540d3efb128bce7c0523dbe8ec316c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f482896c7852fcaece1cb4604c0b32f6a05a324d873e718581a68878fc05f93c"
    sha256 cellar: :any,                 arm64_big_sur:  "2dee856e23aba7147f1f14263ee92b233e4aa60008ecb4e4e531c671fc72790d"
    sha256 cellar: :any,                 monterey:       "fc31c7a0b0ee1f4c5fa5a2c7db12b28c5fd5b235c49742439464b4443108c365"
    sha256 cellar: :any,                 big_sur:        "9f8584b389618398a1e47bacead6b3b36954d43a9ead8790148d2a4380c2c00d"
    sha256 cellar: :any,                 catalina:       "6542fe508ced5de5de6b3f322856ce5522b60d10846f87170f7ad841ae1acb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8a6feb31c0c50b11f764083783f3d6870f81dfab854537fb20f074eb039649f"
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
