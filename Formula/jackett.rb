class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1901.tar.gz"
  sha256 "5704ea8f9b0997162abc6d03ea706c9f20073485c6e65517963e3a381d54c55e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f64b949b381cff3ea0df0fb5f1634d1a97762afd7cbbf331dec150e55a4d571d"
    sha256 cellar: :any,                 arm64_big_sur:  "3c1aba28f52ac2d3d77dd3f04dbad07cd464d62fe855e867a31aaf77ef30e482"
    sha256 cellar: :any,                 monterey:       "5e20d06eb46d33daaea268b1bf638bd01372c3d33d444259dd2cabc9b81cde0c"
    sha256 cellar: :any,                 big_sur:        "a27043bb8dbe10b8f6ecc2f5b38aa391df0bc06ffaccaa78887a283df516d5d6"
    sha256 cellar: :any,                 catalina:       "7777b84fb38020f53da350ce66334bef954cbeac96706b61fb04db43fd11f2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dacbe37881419d0f180c5e723295209b50446eab6cce8dd4d6876e743df839e5"
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
