class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3150.tar.gz"
  sha256 "09998e8b7a09d00b72ba0f4b8f14a6427368abdb976642eafdd7a3d89002b471"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a8ae46ac228927e4e1d7dcee9bd22d8292a9274662bbabfdb14e526361534b0"
    sha256 cellar: :any,                 arm64_monterey: "075970692effdcc3ac0f0fceaf9c088f684357bc06efd9ec09c62650caee116a"
    sha256 cellar: :any,                 arm64_big_sur:  "25a8175484048bd0670b9ff1d7bb5fca46309a8c71377f74a1df52568cee50a5"
    sha256 cellar: :any,                 ventura:        "a87ea2749483a938bc3e6267749e35eab6f1042f3a19419807d7526c45c97991"
    sha256 cellar: :any,                 monterey:       "1ee520d4c4aaab196eb71a29813894fa98a53171510a75df7d06267dea106dba"
    sha256 cellar: :any,                 big_sur:        "ad5ceec5588601986723f681db8dc91ddb362fccafd2167d4f69e9436a2bae6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6626935e45edff0d20216386f828c35e23e32aa35083b9c77181fd228ebd5eb4"
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
