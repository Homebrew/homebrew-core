class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.987.tar.gz"
  sha256 "636d2881afbafe26a769eaa5cdc4a3eb6fbc07f87ea0dd2e289d36ca29e9e798"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "574584606c8ca819d3d363335478c2a8194e5d6d7c5c0010c70e3bef9104c295"
    sha256 cellar: :any,                 arm64_monterey: "c7d8ae1a5de3ed3705bb33c70f7b77021ce37b7feeafa8abb0ed1984334ba7b5"
    sha256 cellar: :any,                 ventura:        "7f23e2886fb6f08b9ef6f3ea72a543500ec6b0b638528cc4c7746f5e3f99b90f"
    sha256 cellar: :any,                 monterey:       "ed628bc7a94e76354c510738be11f2f0d2d38a8388922e475c7e7ed1a8286285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6e6577f60f3bbc414d5ccb7970d68d342e94e57976b8a22839a6e4919e5e91"
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
