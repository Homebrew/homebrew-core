class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2614.tar.gz"
  sha256 "417ecc34412268623790be54e4b0a207c463639afea75006ebe2a8f1a26e9bbe"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a04c5464c1ebcc60fc6ddedfbe563d2ccd55569f71e7046ac5dc5864562f0639"
    sha256 cellar: :any,                 arm64_monterey: "698ab4509a75899258a31926acee84b2be828eb42476b79e21cff093d70f0383"
    sha256 cellar: :any,                 arm64_big_sur:  "8c46d5036fa0345261907348b4f6c4062842a5728ca447c29d85437f425c6da3"
    sha256 cellar: :any,                 ventura:        "342e41f7f754a38f67652009e21ea3acdeefeb221cc5ba475bf3f542f686e97e"
    sha256 cellar: :any,                 monterey:       "ec169c37d83ca8b2dc03aa41d38a66c9bee173a1b96ead7aaac736d8d18c1eaf"
    sha256 cellar: :any,                 big_sur:        "8d0f38eb5b2a7155d9cb8455d069ab4802bee60ce32426b6b79331285157b3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de622d246c0af564696dc7895390e3e7c7b2e023f48b3ca1352df2a5c7919a36"
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
