class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2142.tar.gz"
  sha256 "cbd82117fc71f9e7b5b20409cf9ed430ed7fd628f995b4726ecabec173a8c024"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b7376a0e1c9c21532af65edc4f5c5562c7d7351a39eef4b7f23835526a8138f7"
    sha256 cellar: :any,                 arm64_big_sur:  "b469764045c6b2369aad4570e86328fb5a441637c58cdf2db0107e7dd1fe98e7"
    sha256 cellar: :any,                 monterey:       "6cd268ed15dc4b13a29e6b81fcf15e93909500226b570a44764400956c617659"
    sha256 cellar: :any,                 big_sur:        "6440b60429cf8c2cc0c25c866b707b16aa03224905460afae456caaf1337ca0d"
    sha256 cellar: :any,                 catalina:       "6aee3eb2bc4be991c2168a9d8299ddf1cbf67615738d6cf7702052f9605974b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7012b7e868e456349bad237d4c133f340653eba6659ff449ce2bd97fba635f"
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
