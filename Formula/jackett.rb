class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.364.tar.gz"
  sha256 "8b6aefab863729b69716fcdb1a53a434d816bb58373a19afa6b4415a9a12d390"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f25f10f78260e9016afbd164684a08316256068e670432ecfbeeb8b896ab5b9f"
    sha256 cellar: :any,                 arm64_monterey: "3b6215b5442592b2d5eb66fa14a933aa452ba12c5994af95b146ca2b5555e0b7"
    sha256 cellar: :any,                 arm64_big_sur:  "60563632dd1317191e82fe6a6e678955261275c07500853b4b395125a4f85fd2"
    sha256 cellar: :any,                 ventura:        "5eb5ca92cfa7e7f414a7ac7979300dd5a23a0eecadbb78f614ec2a2e42b9e938"
    sha256 cellar: :any,                 monterey:       "d09e6c378f98ae1e5653e83a88fcf287de9b732a500d0fcaed0a81bee2543e41"
    sha256 cellar: :any,                 big_sur:        "1ff67351868c55ce5dd48e005dddf655fcde88811a3c9f48761be8b2c969fefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1ba3305fd323b4255c00c2a0cb56864c1da9c05dfdf03bbfbdec3b0838527c"
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
