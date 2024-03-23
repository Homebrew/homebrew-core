class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2140.tar.gz"
  sha256 "91c793b5a01902225df2da3d7157515e702e2208f2304bfff0c051722772807d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e8b174228845183c6f890c2ebd93a081dcb206d1c75a9bc318895f6ab3af93f"
    sha256 cellar: :any,                 arm64_monterey: "e9d50e3484a64916908d8236ff951473d27508f97ffd24b1458894ac96e08c36"
    sha256 cellar: :any,                 ventura:        "dd73f9d3e9a4612d111648b8c7485a09467a392f51e9f4802265323e29b72cc9"
    sha256 cellar: :any,                 monterey:       "a12ac6254129946f6a4333e66ddc1feb9d50e2682d34fd5e203301c5cd3f2eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e1dccb55c3f2af1264a79ffc5c9d5e05646fdda12d0f3fb69bb7a5fff37fb4"
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
    working_dir opt_libexec
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
