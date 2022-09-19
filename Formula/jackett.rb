class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1913.tar.gz"
  sha256 "914d99448f54436b650a6b0b96c5a78c8280670da26031aaef86279c1f78a850"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e4ed9789cd5d309716c9a84efb91ab34df695a5ca31dc580fc95ad027ff02cd"
    sha256 cellar: :any,                 arm64_big_sur:  "c1671cb99998c0f146f44f50df64bdc3a4bf22bed6dab4a1736b9d5176bf4a74"
    sha256 cellar: :any,                 monterey:       "f2a891ccf2c73e4223815753f77c16678066fd988bd095d5260741ef8a0465e6"
    sha256 cellar: :any,                 big_sur:        "2c6ed444b7a9dcdf9047e62a40e5def32cd2cc87c1096c81bd8d72007ebbf424"
    sha256 cellar: :any,                 catalina:       "448533a9ed0658f086873e2809bbb978a05e23ffb6d6bc2ce8c58f7de69aa620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a282286b62b4ac3843d1ce8439671ae72491015ec95a1460528454f211ec39"
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
