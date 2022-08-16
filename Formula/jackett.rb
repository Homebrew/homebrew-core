class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1687.tar.gz"
  sha256 "d88e7688652f9eb4ecb2eacc8aa895055e87698bc56051494dcc7591ceee94fc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b6a8bf4e9646249b85e6be602a6a18dedc6ad34718d9b7d15d385510001accd"
    sha256 cellar: :any,                 arm64_big_sur:  "529450744727a19b6d0f33f550601fc0505327716ec94b673ef2ef3a423ae414"
    sha256 cellar: :any,                 monterey:       "c83c24aefe2d82c12d01f6a0969d2c83d106bcb071d3a00917ef4f8dcc1f3e8d"
    sha256 cellar: :any,                 big_sur:        "610e949ec7f40f8d4415320e60057a383f37368232cf28328fcb28f9213df4c5"
    sha256 cellar: :any,                 catalina:       "4d684f65611893de5e490e55cf7be8bcf5fdf16ea2301986558b99f4bf33b278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "119a29f2025b84f1d7345c850c671f7674ba50439209a3e76fb9afdb89b504e7"
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
