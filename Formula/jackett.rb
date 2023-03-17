class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3617.tar.gz"
  sha256 "396decd1f3e97f24ca5bc5ec1e66c389fb1482fb8406411c99067f537dc3e56a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "967d06595d7b3ce4b4408412179c3fe2378bcd1bd0fa36a54f44ddac09e23153"
    sha256 cellar: :any,                 arm64_monterey: "e721967223d515efe01aca65d8209634562f63f7024c9b311e98cd9a375e82c3"
    sha256 cellar: :any,                 arm64_big_sur:  "e92376033bbbeadf92893e74d81708e2df20aec1425b2af389d43bb4c50e5db0"
    sha256 cellar: :any,                 ventura:        "4cd7070ea862cbec1c649d8ea585e6dc1260bf4df994d01defefbd6ae958907c"
    sha256 cellar: :any,                 monterey:       "120cce84d94eb353fc616376561ac6f92c7505afbccd4b1e448104663eb16962"
    sha256 cellar: :any,                 big_sur:        "7ba89560bb504b306ba93bd6dad01bd73125728b7a0823da81f9564d10f773e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8b7cee2a09d4c6fbb3f4456b29c8ab5221f3b217a8d18581074c64026acfa1"
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
