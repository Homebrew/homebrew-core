class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2011.tar.gz"
  sha256 "ee5daf4037b9840aa0d286c872e2398eee6dad43574d78f17da6582ba9197359"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "19c8d6ab2ef00a375adcb73fb3394aff2642c8aed07b8c537f65fab70f81511b"
    sha256 cellar: :any,                 arm64_monterey: "2fb5cd9dfd4040e9f6282569803b1ce97a3e3220a45fd9b76366a9442a256b19"
    sha256 cellar: :any,                 ventura:        "502c83051f853702680e119bcee511e029faa062846f9e105bf57c51e18f9a69"
    sha256 cellar: :any,                 monterey:       "4a590115c61a8b0277f980f5ef7bab77c393714a6f9979b51adbcb4cecae5581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b19f727b2fb4a7c5835f360b1b91681fe136167876e77da92879853eb02681b"
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
