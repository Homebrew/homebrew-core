class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3184.tar.gz"
  sha256 "13ae64658225bdae9685450eadfc22309af2a7f730a6dbc3adeb4afd72fb618a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "221a7f3e296c33c3ab28962516c7b537b45698f6de2a3cebb53fad30736d4b9d"
    sha256 cellar: :any,                 arm64_monterey: "7fd9bc9faa80a2bb5787c20c52d0de354e38627d72af984036230fb7242d842a"
    sha256 cellar: :any,                 arm64_big_sur:  "c3b50c62642dcf7c7367df68ecd782b758997865322c6686a61fe412e6ee5fab"
    sha256 cellar: :any,                 ventura:        "e3847a53c11ceae9febe7d765cbf4025083325de1a2cc722f4a847361c6f9ca1"
    sha256 cellar: :any,                 monterey:       "e0cb1271b9bd48ae149bd39081953a1077320766028a160a05cc2706631cdbc6"
    sha256 cellar: :any,                 big_sur:        "03b2a4068c2164ac437a6d21cc49cd97839f57b0109c8f52eeeb5f551584ac74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065966a965f8ca849440f5fc1f74a4a8a37824b63db35d8f4cf51804658dff82"
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
