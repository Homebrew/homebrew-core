class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.671.tar.gz"
  sha256 "bbbda36f977dae77df20bf24895852f991d54b97118e6bf4eecdfe99de47fc95"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "417a04594ed094efa90f6213602a8633e43ef546922ffd0c467c9106579dbe32"
    sha256 cellar: :any,                 arm64_monterey: "524610ad047252505441d093790be4f9859e19871781fec47d80220e5210bed0"
    sha256 cellar: :any,                 arm64_big_sur:  "95b73dadbfc2e3662a25ab89c724244f62f9adcf204e75d56e699b63638ab0ca"
    sha256 cellar: :any,                 ventura:        "848a68c100f142690f9f16a967a55acc2200f250cc5f72ce88bcb5de7f69a777"
    sha256 cellar: :any,                 monterey:       "8683850a4d11b6fb06bb45447515757d351e1c6043dbfe85b8495fe6eb40cf4a"
    sha256 cellar: :any,                 big_sur:        "a32e90024fe097eaebef81aba13a05f2bf6f39ba18cd16ba3b422f8ef13a32c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e361d25daa492d9324ad2c6d58dcc50ce60257443e6ddc47ad02fe9099c274c"
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
