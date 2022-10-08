class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2093.tar.gz"
  sha256 "9f011e2404c4f3ab4c949b59895887b7d6df37fce0f43ffe0bdb897ec0df9f4f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "455989cb51da74f153e0ece9b4419a7884b24ce3e2442a2388fcf8bbbb15dfa5"
    sha256 cellar: :any,                 arm64_big_sur:  "d04b7286e4ee20f377f8eec11eb611dc3c2c669efafc0b52e27db668b7ae4c6b"
    sha256 cellar: :any,                 monterey:       "cfd6023f86214d27d066b7ed27d355dedd3acf9847a44dbab215aad44390c5b9"
    sha256 cellar: :any,                 big_sur:        "c760d736857dacc0d3677e5865e34a8bb1df5e459f286b29fc40066fb1fe9a1f"
    sha256 cellar: :any,                 catalina:       "dd296913d94fcd4b2e1aa09058b5c6c61b2a8ee88908aba0619785653f4f29b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ffaeefcbe786198d9b96ea23bebad50a27ec6af701a8ab0f4fc762c623976b"
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
