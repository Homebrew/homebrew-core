class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3451.tar.gz"
  sha256 "526d464ab6cf23dc01f3d6f330318d4f8c321c80eb47aec0fee12754d4fd228e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "32a8a86e478bf4b0919977297391a4548507e8b5f7598c0420e9ab7c725365fd"
    sha256 cellar: :any,                 arm64_monterey: "5374f9fa17cdab9d090b49137988fccb45731d8c303914eb1a6b432e36d42caf"
    sha256 cellar: :any,                 arm64_big_sur:  "3eb91fbc6d0a4928a8dfe203b097ded6395e2ce153c12896aae5cd3bbf3d34d5"
    sha256 cellar: :any,                 ventura:        "34025201d98d669c9878b638fceffb82202e08e2575dcb7f21dedc3c3005cf7c"
    sha256 cellar: :any,                 monterey:       "c8431c6b2ca994f4fb6b5fd9375a7a0225f7e916d4db7bee8fd878f28c473d98"
    sha256 cellar: :any,                 big_sur:        "e0f83c5e79562537cea3fb2439ae6ac53d164c142485fd82775252b5a68a0bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fb9336011d7e02a8aa7cdc119845971cc7d4ab273c768e10933005d90931e2"
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
