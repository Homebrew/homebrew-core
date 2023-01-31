class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2782.tar.gz"
  sha256 "90fd36057c92e00bb25c7f71ad85c3718cc335f1291e064f53c7eb6442c8d4c7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2dbc6422bb66f4a1c1cd71036bedd890d56c8eb2a813c7c8fe5721eba371b755"
    sha256 cellar: :any,                 arm64_monterey: "4927932b204b603cac9ae1ca73a2dafc29a73e908389d33dfcb3731784499bc7"
    sha256 cellar: :any,                 arm64_big_sur:  "60e49d61ee4675b159a1d3cd528e8f8e8ecefcd2ba9d242565040ceb46d40693"
    sha256 cellar: :any,                 ventura:        "270e4291ff16368a5e36744bebe648204b8ec8391fc77337fdc3c3cbb85239f9"
    sha256 cellar: :any,                 monterey:       "5b8177d12aa6fd52bc0e38af880899de80006ef52d48d82b300b754e9a1201e9"
    sha256 cellar: :any,                 big_sur:        "118646ce450246e4294b831dc152157a6a04e57c03171c43c9f7b82a97e4c441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752ab3478bfca5034460af328821a800710fc9dd72d77228daa20bb1fbf9a9cd"
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
