class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2608.tar.gz"
  sha256 "645c0c61a09fafb144f38812beeecf9007755147325bb428ca750f918969d40a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b4b0e6cdf5e909a5710592eaa1e27924d77cb8d0c1ad340b74881172e3aa9a0"
    sha256 cellar: :any,                 arm64_monterey: "e42d4de0b9225156ba6d9396d620e276018cd715c1ccb088ac8021451a32455a"
    sha256 cellar: :any,                 arm64_big_sur:  "82c7b3273b84c5c2a3b2ed2200cd8fa0e1ea23184aa298eda28dc0278c007de4"
    sha256 cellar: :any,                 ventura:        "80c636ae47e939cba890c2b02bf127c2338d1498d14f4382dbd5c88440556b5d"
    sha256 cellar: :any,                 monterey:       "4bacdfeb0fe441460bddd662dedbf424b9a7c4a156d1e22beefc737653cf508b"
    sha256 cellar: :any,                 big_sur:        "49805767592c4beb02aeb514eb534b0e5c985d4a28fd103ebc2ef7fc2b6a69f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af11161fcf884d04ee6b4bf0b9b2f7255946d4a0b64326737bb18f5ccbdd33d7"
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
