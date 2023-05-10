class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4132.tar.gz"
  sha256 "06470e79d9fc40e78bfab24d3ecadb49ad842f1770f3ff31e4d3984bdfa8a186"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1250796a42c33ffe42fb84fd42abf33674f84a236c85cc0d48b43252a4a5e329"
    sha256 cellar: :any,                 arm64_monterey: "2254d910d71a9e256be27a24ea53f5587a48cceca5cbe802c8e7a906a39b6c1e"
    sha256 cellar: :any,                 arm64_big_sur:  "1da5186a47b98ce94778144956a84f1de3e4c244cb26988c408554d6d78322a3"
    sha256 cellar: :any,                 ventura:        "663d134ede5689195ceea64bc40df5a0d9c3dde1ad980a25b95221626e3d8ae2"
    sha256 cellar: :any,                 monterey:       "225967bd460af668a82263f65aa39e28ffc896ef1c720f983977519e5b2cd66c"
    sha256 cellar: :any,                 big_sur:        "66d53eeda22fa4841766743b2ae94ead0d6e39f05cdf3581b59a19694335e989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4146cd23f99dbdb718017855a704384db09ff941d68066f5ca31134ac2d698d5"
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
