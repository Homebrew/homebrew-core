class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2069.tar.gz"
  sha256 "02e2ad083cb69d591a4459acdaa09ac147baf3a149c67b0c1761bf9ecf126ce6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1576e716436ea3f0071fe97a260db23d5fe56c8f39f39aa81cffffa0034c75a9"
    sha256 cellar: :any,                 arm64_monterey: "0abf63e079d1de92166dc8d2b80f9f813c0b842ea96cef5adda7a8bfe1cf0776"
    sha256 cellar: :any,                 ventura:        "781f038c1beee68eb4c2225b0873697d90e9ccd46d9111b556303a866cae692a"
    sha256 cellar: :any,                 monterey:       "5d50d89342ad487dc393a620bcb089b749d70d5466a35b1cefe0aedcaacd712a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87857a70a2f0414f767833e32af162369c5e992664ef3c15880d08b8a8ba1ed0"
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
