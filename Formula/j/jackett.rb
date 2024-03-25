class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2146.tar.gz"
  sha256 "bd0d2f4161efb85395d0c86772fb73da7f28acc4a0b8afa9071790a8a298312d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fec4c5607790c75ce82b6be58e99718232da56c321779ad5c1a3192b16b6a3d"
    sha256 cellar: :any,                 arm64_monterey: "246529075408b1222afab2b0c59d44ea326ac844b6d6d53e8097b836704a58a8"
    sha256 cellar: :any,                 ventura:        "31613d130340b4dffa1bb718148200b966ce1de4c5207bc262fb33e4de4423bc"
    sha256 cellar: :any,                 monterey:       "89be7f2ae27b8b18330eb4e8f676470e01908a858696cdafca542eca7de526fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb506a43ce0f1c88f466e4052a53ceac913fd72698fe8c3b6b7501ed3cd1d5d"
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
