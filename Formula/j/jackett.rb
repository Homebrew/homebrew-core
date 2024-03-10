class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1991.tar.gz"
  sha256 "c0827726202fae62fce467051276f84c53e6aaad4a1e911525c9ce030b11de80"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b85a0f0e4d65f7a91411296a8ff1182c3e29ff61c06bcffbb03e9b8574dee2c3"
    sha256 cellar: :any,                 arm64_monterey: "5b50f32daaef9ec031e8d6bb19ef253b419a4252971fb0c5a9063a2bad21ce8c"
    sha256 cellar: :any,                 ventura:        "00cb4e9322e7c53cfbe63dc0119d4891454970cbe359884df63ce90e489d666b"
    sha256 cellar: :any,                 monterey:       "2c165541f995289aa4ffbe9418889c60c418c3317f598658e63248f0d2b0a996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66623b79553113a20e5c001023c5e92efdc23033c9b3a84fc6a0ff72c55aac4b"
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
