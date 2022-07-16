class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1307.tar.gz"
  sha256 "0d44e485c9ca9142af435a62e22e8610323df92996125cb5678e27e38387e7bd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3dcdc1197963115d0491708ea2b50133ce29961192938a3b9d9c67bcb0bd0630"
    sha256 cellar: :any,                 arm64_big_sur:  "323854dcee45c9411e92442502d07eb7df5ee0bb2c8fb4a02c3085affa2ec1e8"
    sha256 cellar: :any,                 monterey:       "c808e5d07c318c01ba6da8fb04e066d2303c44edd39c53613835a4938b9ec5ff"
    sha256 cellar: :any,                 big_sur:        "071572029469290eb1e9d9c08b508b872046b90134935665b1803235f2da8304"
    sha256 cellar: :any,                 catalina:       "43f1aa3ef04708e26576402345d145e236afa6a99a4c9cd6f34f44e440bb3ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43092b4d54b52eff11be79155468626c7e82b0457b4a8969a20be9c27717734e"
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
