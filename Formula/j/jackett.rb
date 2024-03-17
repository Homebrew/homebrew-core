class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2056.tar.gz"
  sha256 "7cf926f91ad164c4d7212a4d345ccf260d520e52e1a71603ecb045e595cbdd0e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dbc731c768043f93fd1d5b9a9a178de5d1ec14b851cb029c8b10e74288799681"
    sha256 cellar: :any,                 arm64_monterey: "956884998d366a5554a7014c05a258db9c364498e4c5ebf5f1f6f9b60f9b1adf"
    sha256 cellar: :any,                 ventura:        "b40c3369a600eea20ae1aa332d370f18547e4f44ca038aab1d64030a24ba40f6"
    sha256 cellar: :any,                 monterey:       "dcb4d97810ab0742261e81b0f81db1dbe285f963435f22c32c9549b8409988a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5eaff6e04da7c4649c8029630cd8a939b3504e314fe7c38acc567cd4360e9d1"
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
