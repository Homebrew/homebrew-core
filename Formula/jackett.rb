class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3678.tar.gz"
  sha256 "f8c6b70942f070ca37ad9165223dc1440a1a8ca6667fe1e3b9fff7b6a8f5e50c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a64f6baca28738ed88f333e413a482e5c1cf8b5d21dd0af08d67f7afa45a5592"
    sha256 cellar: :any,                 arm64_monterey: "8ee743606f83f6f1ed29d9c66fc42f5b5204b59809c2c0d8dbc6aa80e4b4d53f"
    sha256 cellar: :any,                 arm64_big_sur:  "e6bbf61c20c0e9c929bb0baa64db5819740b9fa96e51f42bb6c546704f6854ad"
    sha256 cellar: :any,                 ventura:        "4ff4d48a8f5a9594dd33d7efb8e0f20e2c050e5469b514474e281293ffbdef83"
    sha256 cellar: :any,                 monterey:       "b9c2473eebe7471f184fb4d55eb7472fd029e1154d08e2707a6b74c74639e974"
    sha256 cellar: :any,                 big_sur:        "fa797a3f93687eba4066e496697ff73d83dbcfb58fbeedb3b8a71fcbf9369fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af3fc9c05e7617fbe0e151a19f01342327b4a7fbb55c3359eeb80af877f46e50"
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
