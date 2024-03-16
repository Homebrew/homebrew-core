class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2042.tar.gz"
  sha256 "24dc38b1bf7cd8b323cfb56bc51b44ff228b32a4884d7060d484c2548ba40a8e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19f9896f8c4e360c4b0b9962d3c3fe52d817ea207c6cb43c5778f110180d12b1"
    sha256 cellar: :any,                 arm64_monterey: "18d4055e2e89a6069cd6bb48a156a8997e53a0f82af91a77358f0fd804e3d7d5"
    sha256 cellar: :any,                 ventura:        "13e1ce1e66c36859b5558d5729fa870b9338231c21cd88d2764b91700f653d91"
    sha256 cellar: :any,                 monterey:       "ae20cf0b8f3c5deae3b044b7b5ec305f223825c1853acc655505f34c15bdc941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3795d5234d0b303e3f426d4d7b10b3fc9c586f5df436dd73c19cd26599cef41"
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
