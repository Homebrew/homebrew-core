class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1825.tar.gz"
  sha256 "904520f2eac54e1c2a51fd314041529fdf67915d806b7a1f56ce818c5bc5db94"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ce2dfbcb1a91139a66a076e06759a1230702fc8fbf727f6b4eb6c69e7b486b82"
    sha256 cellar: :any,                 arm64_big_sur:  "6ec91ce2ddaa10bcf0e66a04643d0f0bac4fc6e735653dcd006620c2eeb285ea"
    sha256 cellar: :any,                 monterey:       "6d0beaceba8ca370c6d8f5414692615148b466095ef1df2454fa535165e0aab7"
    sha256 cellar: :any,                 big_sur:        "3cbfd72caa7423a32d75677ad1f2f94e5438cda2c5dc28e00a068682642eba03"
    sha256 cellar: :any,                 catalina:       "82da5d449dad1433146fc9048259f367c4b999345174f22de5be201ca8c87571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1c4d80f83cf0181cda83b661aaaf02db86ac5acfdf17ec9357be8a3a4035123"
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
