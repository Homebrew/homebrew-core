class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2175.tar.gz"
  sha256 "0cee562a2feb75157521c7e05dc7f910ede5f5be3ef22af99ad0422f994db58a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ab6e6a45fd34f07d73633e26d57f4c82ce5aef966ff864fd2038020488e19b3"
    sha256 cellar: :any,                 arm64_big_sur:  "58f2cb189f972d1483eaf57b2e4549d4547cabe08c92a026e386164dcf24a83f"
    sha256 cellar: :any,                 monterey:       "55be5bd024f15643c14a821065183f78c4a258820d93fbf0f203853051acba0a"
    sha256 cellar: :any,                 big_sur:        "28a50c6ad862e4cdc9fc0dc51cd0244590dcf377a6bdfe0378453bd58d36e81a"
    sha256 cellar: :any,                 catalina:       "257c4b1530176e3a5b00a53c84f05949a61163a21cac79a7d3396b0b25b19b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9690890bb9de30fb968bc0160f1bb2360c6b66d9f1b0acbde52306abdea4fa0"
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
