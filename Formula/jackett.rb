class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2986.tar.gz"
  sha256 "42310070802fb4ca56c6a0c4acacb4eaa450e02a60a06263784e86e8b7a84937"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4970cc1a06e770d4985eb8fc92f5b49f08cd7510ad460b91e7dff19ef05ba03d"
    sha256 cellar: :any,                 arm64_monterey: "23246a97eadff6463aa1a66b9f6472987d69caba744b656c2e2995fd05652f0a"
    sha256 cellar: :any,                 arm64_big_sur:  "59230ea8184d6c85079ce53b06c72a1aa87aa94a3f45fed35d76b6b38f26df6c"
    sha256 cellar: :any,                 ventura:        "2cfe3177002777d5fbdb04fc4ec6c7fdc54b54cb9dae6a2712395b3536d4fcb0"
    sha256 cellar: :any,                 monterey:       "d9999c998959986da19436bc925a8c262bd6a3ec3c553a0da420dff209fee42f"
    sha256 cellar: :any,                 big_sur:        "6c8563c8c32227d9841e1eeae5051fe890263bec6244fd6c7a6303ecb2885522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b613043332614c19353a2c966b9138a9e903c8004268ba6d67fa77be2156222"
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
