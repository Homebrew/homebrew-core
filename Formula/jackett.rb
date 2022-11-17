class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2260.tar.gz"
  sha256 "3b4e18db2494c4263ab2824c212988d147e423da7423de122589ccb4690debac"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c2507d7ffd388581ab2855a3fa5f58a7213616056a3d54cf0b35a738c8f546d"
    sha256 cellar: :any,                 arm64_monterey: "431867296a89296330295baa5f6b80a343d10f9d78e3a998fcd64d7fcab5bd1b"
    sha256 cellar: :any,                 arm64_big_sur:  "cd3ac04a0179206d0c8cf215485757f0a7c65a4132eb07dad5ab5d2326998d11"
    sha256 cellar: :any,                 monterey:       "379414f602e8fcfe95088fb8c056109efb4a256b3dead56c7b9cc3090d1732aa"
    sha256 cellar: :any,                 big_sur:        "c6d1bcd11c47c8758bd13d631ce1638bdb55b94b6b23193c2a225bcd3b76adeb"
    sha256 cellar: :any,                 catalina:       "cba21185cedbf55d7ab209fea411f8660ec24ea52adc3384c2b926c99d1ae8c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4417ae610c55b63982cafd1f6d9addaf066fb3f178e8565f0d11fee3a0e004"
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
