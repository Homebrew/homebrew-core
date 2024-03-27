class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2175.tar.gz"
  sha256 "c97a20f383cae16e742c9519801b1fe73436f46528a454f62a015ef4bd043183"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "777fafe3433813924e4e0a651b2d8a4c91fc53a4a20a1771e5bdde26dca3ed8e"
    sha256 cellar: :any,                 arm64_monterey: "d5db1987fc7e76f5f0921f174451a0ac9d930b1240ce34c39b4efa96aee21600"
    sha256 cellar: :any,                 ventura:        "a42a37da5086b59f74222f6e3fb7d463441cece442c840e131723683869909ee"
    sha256 cellar: :any,                 monterey:       "fa466ff34d317ac8e32fc754b8bf593100967d18812799aaf5a58a63553b1853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876e059e9e2ba78f51f6266c3e6ccc50aa5221512ff409256927e7ee5ecbee23"
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
