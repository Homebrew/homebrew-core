class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.204.tar.gz"
  sha256 "65ebe38863cafc15ec8a7f34f1abc29995734d242fb62506550950f8eeb9b6d3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6425d80e48a81ed55b2debee33cb1b0e5007cf934935d2cfcd9861775920a8f6"
    sha256 cellar: :any,                 arm64_monterey: "0264561c67198253086816076149a384d7157938b78ea57dd564d757afc9efc6"
    sha256 cellar: :any,                 arm64_big_sur:  "7db9504b81c3f5e9adbac7712e8a563165b3d51220b65117693a3d1aaf459d2d"
    sha256 cellar: :any,                 ventura:        "ab1a5e14520fef23f37d2d6ff83a606495097cd35f20942f584aab5dfbc5ab66"
    sha256 cellar: :any,                 monterey:       "15e6234e91e1da37e5307f9406389b3f0d1ed58d43e0be0434d3233f40a17526"
    sha256 cellar: :any,                 big_sur:        "01f65acfaa3a879b9f6b47352b50787ae3ed4609035e898f68c416bb64eb3364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28bd55fb8d0dabb251477331b31b3a27e2d34fcdfddef4c699238078a462aed9"
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
