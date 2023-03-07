class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3521.tar.gz"
  sha256 "26731250d5ee8abb52762dc1438a98a2d3c3e6bef12cfe07431b12bc69104c3c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59cb992a2c266d5b51e0d149ec596be6a980c70329bb2250bd92a6fe431390cb"
    sha256 cellar: :any,                 arm64_monterey: "196660965c83722b92b4dfa9612c380f0f65077c077d3e730883f0c686df9aae"
    sha256 cellar: :any,                 arm64_big_sur:  "c3bc7823715f4cba6b845c184d6694ef7b05e85358bdad28ccdf867cfa028718"
    sha256 cellar: :any,                 ventura:        "0723a3127b8189a76dd10142087035f7b97ce233af6066389fff9671e92fc5a7"
    sha256 cellar: :any,                 monterey:       "cc0b18140f2c12af666936db6fc15c94aa86028322145d8c3c0e147a13fa2f85"
    sha256 cellar: :any,                 big_sur:        "8b0f7cb04e778b13a5e78ee62b17c10f2dda04385e06992eab86feaeb850b587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfccca3fb528d7cbc7de463bbe11e321e97ca33e54a7daa2657a961fb5062a97"
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
