class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2034.tar.gz"
  sha256 "d5b5783d5fccf4f2e23a78cdb511dcf55fe379ca300be74157e6f1a5767dffa2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1583e6673cd0835475f3a87de885d12aca0d6583b5f3c34b851db5e3d1346950"
    sha256 cellar: :any,                 arm64_big_sur:  "b095bd98920b1abb586b41edc6b43d7898d0bbc2b6e83e5f4f1086164fc60ab3"
    sha256 cellar: :any,                 monterey:       "5018a60c493d946ce8fcaa3012e463f7fef71bd1644c3d331940044e9777b2c6"
    sha256 cellar: :any,                 big_sur:        "334a6495c4ecd834b904b01b90d395624064ab58716b80d8ebe92122f6808dff"
    sha256 cellar: :any,                 catalina:       "3c2bfa693537c0e4f4b989c15931b38732561dc3bfb0ac79064c6e817e4af603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16776152ff0b972e5f09747d66e552b7ccd6e4040d6ef511be84d9f3158ceff3"
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
