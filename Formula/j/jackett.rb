class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.772.tar.gz"
  sha256 "2b13502b99d6bc79ec7666fd60b8f24863a5a705283791bcbec5a94ff31d1713"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "229c585a3eca8cb78347e5638c080dcac8644635fdac044d38530f39ee6a928d"
    sha256 cellar: :any,                 arm64_sonoma:  "e225e1fb55c2c65d1625144e7da5e8790518b850d7c4f368bb4e8b3ca3798953"
    sha256 cellar: :any,                 arm64_ventura: "f5d286e8b40f70a7d9cf37def45d0f177dd92b6802a2f6de43db235b2a30dd1b"
    sha256 cellar: :any,                 sonoma:        "ad70b67eb2823478151bdfab3db6d946d5274d9957c2324dad3406af944b4079"
    sha256 cellar: :any,                 ventura:       "725cf4119983e1f37c56ca9ff3930f07341fc154185aa9ae0790aac66c2082de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfaf0435d6ca6e4cd45bc5072b5fbb63902915964ebda0d7cce2886df769a982"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
