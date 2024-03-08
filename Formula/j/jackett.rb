class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1973.tar.gz"
  sha256 "3a59fb55f3246a06768e885d2f82881105df688b6c53a5c27062bc38cb30ec47"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fac14a70899bce3cf7c923e95e0a71fe07a51ac62b3d2e83b30aa06d048c39a0"
    sha256 cellar: :any,                 arm64_monterey: "3f92686001530d07c8579163efe55bd2554e7a83a7dfa1b06920e985f4aa1e1c"
    sha256 cellar: :any,                 ventura:        "c6ffe870af544532b5fa7179ded4be80462c946c8ae205e88f808121c67f7206"
    sha256 cellar: :any,                 monterey:       "487f163d3752f4cb184ad136201a59cac6c02e381fb4b01b10d526180b66f609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6463b2e587f0c062a0d9f349b2ca48c013bf8aea569179d651118452b3fc2f2d"
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
