class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1796.tar.gz"
  sha256 "d3c4a274fc6508af0c8ef91967b9ba9fd853f039a6e75486557c213875f49458"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0edc6c5be0b64c5a3148b6f4cff2a729ff1cc31d3a7a54ea9e3d78cb596261ee"
    sha256 cellar: :any,                 arm64_big_sur:  "d90020cf3bd75f9eaa40520edf1915cb68993facf6e7dfe04300ca73d9d2ab86"
    sha256 cellar: :any,                 monterey:       "67cd2561f9cf64512b7dd7d7006f44646052d68bfcbabebf0291017228f7dafe"
    sha256 cellar: :any,                 big_sur:        "dc45bf42b80fce1a199e59af50f4fb933eb1f47518743494544686c0535cc793"
    sha256 cellar: :any,                 catalina:       "d42bb0270cb62252b9310dec6732b2927bc22f5ff30f27553a8e4d072ede93e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e96d10bf06ad72a34af8f56c8a66e16922185aa7f4bc7430bf1feeb5836f9653"
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
