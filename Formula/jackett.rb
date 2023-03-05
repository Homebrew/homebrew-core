class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3463.tar.gz"
  sha256 "b39303243777b23150b5ceb66cdfc0b20d98840a397d99765c0126d73f342c00"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bda6c5933e3f4570796bacb9eb0e417c99575ac4c94a169aad9334762130e8ae"
    sha256 cellar: :any,                 arm64_monterey: "2b78c9c19479ab6a43bb3bce584cb1461c7da3b0a4d2b0a43b27ac3ce9e7f293"
    sha256 cellar: :any,                 arm64_big_sur:  "5d0f8b769307b761f0bb2c44770cc469fd0129d3033d82fa52ff8c8ecfe20b54"
    sha256 cellar: :any,                 ventura:        "132fc69ed82302f718e88ab7319b1b085eb9ed42b3bcba900c5a1d569d9279e8"
    sha256 cellar: :any,                 monterey:       "b5c4b073753bbeacd920efc822db6df33a65eafc72a30ae401b6e9773300da37"
    sha256 cellar: :any,                 big_sur:        "3aad06c417abbdf9f9109b614d93301ff316f09fc2ffd8fb5cf093869f4874ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04df5f86886e0ac271a45a8fe9427d62327b59de4bb9c8199c56ea074808f8b8"
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
