class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2663.tar.gz"
  sha256 "710fe219b47dc121c2e20cc08241d5506abd9de39d73981769b1b0d27ed1cda9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "685351e53400d52943d9d4ab59c9a3a0bae6cba5b0f95571b087975140c417fd"
    sha256 cellar: :any,                 arm64_monterey: "1f56711545cb73222203f4150695d04a6f56137a97d65319183e3004d2f7d347"
    sha256 cellar: :any,                 arm64_big_sur:  "54d901444789a0440ed2b68b615690b3d70320e62e03b7a912b003944c684db0"
    sha256 cellar: :any,                 ventura:        "4e8a76c21f16e96158232f520f562ac36d3ef91f3bbf90948fd2b6fc85ed3f51"
    sha256 cellar: :any,                 monterey:       "68f8efb88bc82f9eb8a559ff5c454adcba5909a0ec76fcca1c27bd9ba078edb1"
    sha256 cellar: :any,                 big_sur:        "fa93ea7350110ae822e45b38b667580d68b447f2f12206e15d64eb095e243cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8760c1af72f1f43c771c5b3ad0612e687b12aed2f6789076edf4adc3dbc835b"
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
