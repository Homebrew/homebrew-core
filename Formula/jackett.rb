class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3599.tar.gz"
  sha256 "6058cdbe46365ce5c353336f62c8b0174fd108146e6f8f30118e497899b193ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8169b1aa566be4c2755a4ec7e32f9be34deec9e02842011d45ed1ede0f7e3e2"
    sha256 cellar: :any,                 arm64_monterey: "6157c2a064f884fcf3e07b95aaccd939b69733e312ef52706875c214f31a6f11"
    sha256 cellar: :any,                 arm64_big_sur:  "f69de5e22dc9b8b75efce936a726c8ec23b14601032359e4a62fb0b03fcdfe5a"
    sha256 cellar: :any,                 ventura:        "88c52534d88637bf68f845a625b577a1a616ae1d0d128e9b9fe8d6ebcb9fd936"
    sha256 cellar: :any,                 monterey:       "e69598a5fd88cf77ccb3c66017bfdde85cdc792b839a227d07ec657f9a171bc7"
    sha256 cellar: :any,                 big_sur:        "36718b3a59d80b987c493d61c9e077759f1a7e6e6b88eccf101d74533cb90bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bb54f0e5f261553d9d8e85c626a29be490650588beef6c8c24e7840dc83a74"
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
