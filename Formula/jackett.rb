class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3546.tar.gz"
  sha256 "2ce06c0042b24876b2332e53bbab6374546c0d551f2abb813c0169604af91de2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06b68ace3cae34b0cd4bc0e7e04496c4a8c9ac5dd4006cb35c1bd76cc2be4538"
    sha256 cellar: :any,                 arm64_monterey: "2f490b44e8c1b61756cffba35e32ca7de21b0f835384b65f3c05dc7166fb6ac6"
    sha256 cellar: :any,                 arm64_big_sur:  "133eea60f03400b925d416469b90eacb6dfa0cb108b1e1719670cfdd8174ee8a"
    sha256 cellar: :any,                 ventura:        "a2c20544b8f795d6cecca93d7a08755ec736d2abeec7c4e1a379a9006dc16fcd"
    sha256 cellar: :any,                 monterey:       "c589d41d294c261b440fe3793ecaffe7a603935c4e07c830740c8299019b7d63"
    sha256 cellar: :any,                 big_sur:        "45cde29188a41be6411a81c031aac1694dc182ea3cc008f7358f8e8190352510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533b54e137a9bc4abc10aca5edd4f63e25fc1fe8e9ee02f4e9466b5596b1d946"
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
