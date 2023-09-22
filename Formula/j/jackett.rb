class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.862.tar.gz"
  sha256 "9a67ce52ec4519e8a8436361bca648fbb3467cfab3300ef0788e5b252adb7bfb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44714e8d0b136d229d9e194f0a9ec6b5e95d62b5aab24801d0e297149f225f4e"
    sha256 cellar: :any,                 arm64_monterey: "dbd18d18c5b00ea8ee3f42a9538b7c903ec6cb859b3de3033f651fd530ba07d9"
    sha256 cellar: :any,                 arm64_big_sur:  "50034b176a6a2525893b058b7226dbfa5c111c322c84b02fb947e3cfb3bdfc32"
    sha256 cellar: :any,                 ventura:        "7b99b5aaaa41b5bf6c7cd744fd4ddea97bfd4135bbdba171089e88b143481aeb"
    sha256 cellar: :any,                 monterey:       "80e2742a4fd47272ccae41b621a0611b5e647669a59cf43757377c597982e5da"
    sha256 cellar: :any,                 big_sur:        "25a6b953d8b14abcf6f6521d3c0ffc5344bae8f252e19db2dde61d3492533309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0297845672408d84ad6b5e1fe9363357071f51f49fba46f8b7708b800fbf74"
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
