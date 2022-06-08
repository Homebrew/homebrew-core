class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1151.tar.gz"
  sha256 "ee5ae7ab6bde5cfcd3fb7d649d89abb952ace08e129572dcbb39697dda0f6b05"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26bdf10aa1b200379b7a9e730279a62a613b693f0ab627cb248270063dd3a481"
    sha256 cellar: :any,                 arm64_big_sur:  "6fabba440585862b30c0118c1cf33fab8e8433748e51d5cca2e2d8da3eb2d931"
    sha256 cellar: :any,                 monterey:       "9999c79e987774419867fea82547798884c23a332f74b2d9218a1e6098dd487e"
    sha256 cellar: :any,                 big_sur:        "79f2f42205946d127f1c1b1aa8c721fcb3fb366c5d24a34e84382446a2d7063f"
    sha256 cellar: :any,                 catalina:       "4ca4de0680974c164f5c86341ba1bbf328596a4225ec518d7e762e8320af6a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "125111a7ac4b7ec62c55c90b3ddf626937c6b0b03d1b48ba6758b58274e7c014"
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
