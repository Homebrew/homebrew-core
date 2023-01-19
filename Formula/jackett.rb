class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2671.tar.gz"
  sha256 "b3335bbe62a9eaa243f987f966c12e55e751fa2bd73c45ae55133b990eda070c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e68f2a5e55024efc259b5f7147f6dbd25bc26fb6a3a0cf26a37d0085f2abe4da"
    sha256 cellar: :any,                 arm64_monterey: "185d84b320a76229fd7207bb9ac806d7bbe81dd5e4853ad539acbff5a9adfd76"
    sha256 cellar: :any,                 arm64_big_sur:  "1bede1ff1c0bf5364d1faea5af5ce64be8389047ae903212ba188707fa97fb64"
    sha256 cellar: :any,                 ventura:        "6aec0342a5cea9f2208ed49f343695654ceae8a9fd5a6bf91021bd31fd6a2dcf"
    sha256 cellar: :any,                 monterey:       "621d05b60e735cc806f216d412097552cfd5f652e59e56c467ce8de4195a4976"
    sha256 cellar: :any,                 big_sur:        "f1f85c0609c05c46fa919212525723ae60a41362b4616a31f4178812e2836ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35107b0dd03250fcf483627c34c79544295ac993ed2e3e58b893e11bdd3da1f1"
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
