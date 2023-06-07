class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.177.tar.gz"
  sha256 "5b3ac87be276c92660e293c5a5ef75e6bad641cf27d475f21c31e55a26db9169"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfeeb31e17223729086d26eb6f08bf78111756054565cedf5c0602c9bbd09c22"
    sha256 cellar: :any,                 arm64_monterey: "5094046ded4ce44bcc7ca2ec7160cfdcd294ccdd15a8345d254f66748352eae3"
    sha256 cellar: :any,                 arm64_big_sur:  "126ccf08408716dfd5bd1ccce18b058eecf32429c83014907ba908f3b7cd64ed"
    sha256 cellar: :any,                 ventura:        "3ff977a2403cfcc353634e532b7e612935bf8ca58a1e34ae378d466fd7bf6bd9"
    sha256 cellar: :any,                 monterey:       "677f44104bdb1881e6335ebc23a3417760d246036d2684a307a0818f89097632"
    sha256 cellar: :any,                 big_sur:        "4266ceba33e18c3042427592e521009d5a534c28724a0c79bd47a348ee4c6cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a1e2d1368432c1a6bf16069bb20fff0b3de602e0ae60433822a33156801332"
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
