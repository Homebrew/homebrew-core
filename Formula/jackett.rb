class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2092.tar.gz"
  sha256 "a3c147eaa2da45500091b28a94ceaee40526d34af7ad84cf3095f86392477dde"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8939044deba995589ac34788b1f4616181f7fd73928f89c0a349234320aff0e3"
    sha256 cellar: :any,                 arm64_big_sur:  "324cab45f562c5f8a26d13c866f149ff72d8c409fef8f0fd0c64fcd9d2a5743a"
    sha256 cellar: :any,                 monterey:       "225b2c2772f66187103d8e90513af4a5038e772450ad9c5a9a131de00c4cbf1a"
    sha256 cellar: :any,                 big_sur:        "a4092757b9f2b712084267e9d741917a18032c9ae57fbf374621d966dff4dc70"
    sha256 cellar: :any,                 catalina:       "adcbde1bd8278a9910609d021ae660798c020fb4cc125fdc87fcb324d945dfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c09646b163b4123fbb7509574ccfd6dbd7b1a2042f36ec0b91fb390984f6241"
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
