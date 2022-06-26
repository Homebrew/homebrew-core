class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1202.tar.gz"
  sha256 "04bec7cb939e3bbeccb90ce1f30dc2d044a96b83ad4221420d2b45bbf57cc276"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ff816433b0c263854a1a80028078220c941bae9f434addd0d3777837e210abc"
    sha256 cellar: :any,                 arm64_big_sur:  "f8b88f768f194073eb80c899c558bbf1f9217ab897505b7baef7f1f311e1d481"
    sha256 cellar: :any,                 monterey:       "d9b5fc07529ae0778418cb329145ec4932dfd9ab387accc4a13c391aa2eff654"
    sha256 cellar: :any,                 big_sur:        "02a48155d21ca1310af01a16215167ba2f79da9f04b1398f9ecd3caf3abcf412"
    sha256 cellar: :any,                 catalina:       "d52a282d874d28e09ed5fa28870a91f00313bf91b6be3d63b64f468b4e6c5e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396b6887697f8a8d92ee6149079958d4cb806fcd5542b3d8233523d62708da2e"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
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
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
