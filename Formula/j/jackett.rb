class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1991.tar.gz"
  sha256 "c0827726202fae62fce467051276f84c53e6aaad4a1e911525c9ce030b11de80"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6c4054fb0ffb6b3eb3f7cc9280826d729acbe5b2e7026ee880eff0b6d7523eb"
    sha256 cellar: :any,                 arm64_monterey: "9472539ac2dded4ffac28ac25d4c61e6a8cad47eae98eee895fac384259bdb88"
    sha256 cellar: :any,                 ventura:        "4466e08f6ed1b43bb349d5fc96e3a570dfe9c5ad07dae2fb3a7f7177989ac426"
    sha256 cellar: :any,                 monterey:       "9c528213ada72e3e6cc0fd84e42a3770aa5677a82e26a2657c08f4077f601826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2df3986f9c0de709510b9d5f56fe2ff5952956aa993af7273520957b060c5c"
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
