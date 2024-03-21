class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2114.tar.gz"
  sha256 "4a0194879014c1ad3443a9bbc646a2327a208c67c39fed16b899193826093f00"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07ba8a0b9203f29ad3b1a9291380c9f6301446d1887b64363a695007cc99cb4b"
    sha256 cellar: :any,                 arm64_monterey: "2c52076661f252c1a2fa65ced224386e707ba584a0cc36bd46ef822d0b3824c6"
    sha256 cellar: :any,                 ventura:        "41ec32ff72d9fa042ae65953f95adf68117ea3e4599c7ecfaca8583963a33d0d"
    sha256 cellar: :any,                 monterey:       "b0173149f8fc3412bdc91d73d16da900bf8ae801a7d191690916a3fb06ff60dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60731e270dc074333e1fac02f960b036f955c6ca79b80e1281670aea7dec20c1"
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
