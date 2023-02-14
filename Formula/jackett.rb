class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3082.tar.gz"
  sha256 "f7c16a0593a98e152ec99c581295112772b7ff1b64718387b84e380a71247a16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27880da2a01ac50d918f018be01d2d1d31f0130907d15bce44205a17846cfb17"
    sha256 cellar: :any,                 arm64_monterey: "ab62807a99c1dee7ec384985da8f6747a5bffb558c2d612ecc5ad76f399480d2"
    sha256 cellar: :any,                 arm64_big_sur:  "65c1b8a531acf34df751f978d84e99c657bc4aced198215cfa90c2683f512fd2"
    sha256 cellar: :any,                 ventura:        "da04fc99495f7f0f9c94f90eefdc72cdafbe2edcefc832abbcc5b8034c8fcf6e"
    sha256 cellar: :any,                 monterey:       "7f1e5f454af79b7f2fa1628a0858c3d619a92b3879fb3690d6bc8dcf4d9720bc"
    sha256 cellar: :any,                 big_sur:        "6ce8f3a9aa9670f7896d35c15c748454fdf413bb95e0294c4a3f3399fed41782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5caf075d18806cb380593221149e8d6b5d260d17f71679be19a8b9ccb2f22aa"
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
