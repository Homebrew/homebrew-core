class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2741.tar.gz"
  sha256 "d4d66d074cefb32d12487dd6677ac18b704df62b002ae9bf763833ee8700f5a2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc68d1142018ee3a78a511b3d078f2c7692f417db6975a02b068e76b36960689"
    sha256 cellar: :any,                 arm64_monterey: "02809a96599ac13b9fd52063ec586087c63b10c98b3abad770dd072dadc999f7"
    sha256 cellar: :any,                 arm64_big_sur:  "fdc8ba8b52d041bbe95f5805bcddac1a006dd8c6346c6d8c37decca94a6e5cf5"
    sha256 cellar: :any,                 ventura:        "c8ce8801f7337418587c95386b37fde5f88a5837457ef9cc20e9a70c66815daf"
    sha256 cellar: :any,                 monterey:       "4f6ca5fd3f11e752d3b2169513c61f334340a660ac6909841ce7f632de648294"
    sha256 cellar: :any,                 big_sur:        "d0fca4864d984e0a89f2b703253a02bb95486d94b4eda91e4e585a775f1f45cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "727c1ffb40b3bde108d91c35acc04f6c15b580c34beb0316160eae4b12e3f132"
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
