class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1292.tar.gz"
  sha256 "af94aec86dc855c61a6949a3a23d6ab9546646069c631e3af63134c6a70bb61c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "531eb90416806553167f69bfc2d71253b869c69247e4fcdfed35e1fdccb85eb6"
    sha256 cellar: :any,                 arm64_big_sur:  "20fa6186e7142c1f8705f8aa9f94a97edb534cd6e22dbfc1626a3d38af15cd4f"
    sha256 cellar: :any,                 monterey:       "acee931cb4b29fb4fbe90bc76cff3ccab44dd338ef5ae6b4eff3f99266b9f091"
    sha256 cellar: :any,                 big_sur:        "2b53e2b808f086a57c1f2c5f9641817e372f141fa52da37da5ae5d34fb1ca5ae"
    sha256 cellar: :any,                 catalina:       "f6fa1aeaa18801f18b02d9382a9167933e2bdf532f3578355ec697f0adafa836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb790ac4911ba4a1fcbea272d89fff51dd01be5aebb75b93d83b893266629bb"
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
