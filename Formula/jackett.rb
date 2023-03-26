class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3682.tar.gz"
  sha256 "2e8fc64cefbcaf4e9ea006f6cc8a983bd27f6b555a553ea2e64135a8a5c0bec1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "256fb27970cf1cf7cead1da0bde9484a7f3dfa46e9f1e2eb6bc3da7daefbdddd"
    sha256 cellar: :any,                 arm64_monterey: "8e71baca950515631f8f8cc94df0677521c4d94bac672cf944260b73a4253596"
    sha256 cellar: :any,                 arm64_big_sur:  "a7fd5a68903eba247229e6ba7579c9420a32997c307299e7a42cf839f8d89e3d"
    sha256 cellar: :any,                 ventura:        "7d9f43f37806f116b479b4c816eca21444978bc8cac4181bcc137411685707c1"
    sha256 cellar: :any,                 monterey:       "f9e73d2efe5032a8b4587c97bcd0438406e560bbc5bd66415bd5984c88d8c331"
    sha256 cellar: :any,                 big_sur:        "bef2f0b24f9380e411b2c295dfc1986b16c1163e9c569bf9c2f4b22013c5c86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae231f4eb54a6e743c6d2b68d6e4b8b6c02f072e0ee733b010bd43a4625be09b"
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
