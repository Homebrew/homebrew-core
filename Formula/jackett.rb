class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3767.tar.gz"
  sha256 "5f4b8576f73ea8447da8896955b47b42b0e66ae99a6a90fcf9caca9501fc1ff6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3cfab9d0d584a2d49e442149cac815fee8cbb1ae700f3aea5e9b2eaf5a992a9b"
    sha256 cellar: :any,                 arm64_monterey: "1f783978f389cde1ba109f5e208a6425673107913a9d50e1588cdab830b752d5"
    sha256 cellar: :any,                 arm64_big_sur:  "e62431c9623c7357426ada9aff84c37d01d40db16fc419257e65c80fe9f366c3"
    sha256 cellar: :any,                 ventura:        "d8283591c7be840a38964abe233af0d267487f7337602001638059f32f2f741a"
    sha256 cellar: :any,                 monterey:       "4dcd9032ce7f16122a9e52e8d2d1255b9e6d33e3c4da85cca8580db3a08f70fa"
    sha256 cellar: :any,                 big_sur:        "b5e00bc0ff73a592ca5fa94e8dd447c9445062817d2b5b5c9ab6a50d12d8e393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02edb739b3a52d2ace4f8f6ea1e048a6203d50dbd3228d0b9b5d2da7c7cfcaa6"
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
