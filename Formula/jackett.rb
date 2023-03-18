class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3627.tar.gz"
  sha256 "759e8961625c7b7fadfb3e7d931a1e42aa35092795d1d2ff3c61d1cbd6780044"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6396c220cbeb9c9d32e53d53b0895dca8ad830cf5c39ad19f01667173f66830"
    sha256 cellar: :any,                 arm64_monterey: "5de4971f6b6e9f3cae461950cab5977679e2b9e363d030b4b43279ec1b5ba495"
    sha256 cellar: :any,                 arm64_big_sur:  "6a5f5c2aa89b1d2741e0bd598f374c8d5e920ddd17fc5ecc2d822a7575282be7"
    sha256 cellar: :any,                 ventura:        "76e1c000f1dc353c5c5c24395c2d1bea6f63b1e24267dbb389023cfb0e09355e"
    sha256 cellar: :any,                 monterey:       "f70627b9adc5b13a74418ac8d4d19c61a5fafcc6ecdb0743417d9de579d0e480"
    sha256 cellar: :any,                 big_sur:        "042ffa0f9d7daa1e3ab3c2b0a72a23ac596969466a902e6d08ac6db5b3a1ba4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1ed00d94a50b73eb94d2ccac5379a899258f757453e0f89b916964fd587bc31"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
