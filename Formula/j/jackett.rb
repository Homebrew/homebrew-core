class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.474.tar.gz"
  sha256 "2e22f0bc3538620f384e2e01f4fb3203503ec07bbb893b98e7952c82c5830661"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f224d392cf28f2890dd75725392c8e4dcb23e179ab3295b342c36db7229f7d6"
    sha256 cellar: :any,                 arm64_ventura:  "314f1f1d3c9a5bcdd59d1542c37d7c4a83891bd3d9f9121d38b71f5507425912"
    sha256 cellar: :any,                 arm64_monterey: "deb0e15b72d096fb803b2ea904e53361873b6440b8b61a18d6a3966dc5961f11"
    sha256 cellar: :any,                 sonoma:         "3bf4b6e50441f31ae49f21393752c4e0f28a6bbdd39a561da7735e2613dd4026"
    sha256 cellar: :any,                 ventura:        "f6875e802f29626718f5424bcec0c8315e894c36d053964ae44873a1f6a8b08b"
    sha256 cellar: :any,                 monterey:       "7cfdc72a2c7cfba735d7faf4db4fd263de6701c01fd1930f2484c8d4fc8024ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d276d5dc303b59b1208dd9e32fd0328544f18e8fae7291bf4e16d81841884945"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
