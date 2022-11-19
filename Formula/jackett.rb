class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2264.tar.gz"
  sha256 "65bca5b66485acf945a695f5e7f89f90df4157473d334e346982281730617459"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "beb2e00022081d428d7c188e7d9a5fce6df2586221fd9431873ba0ed236a33fe"
    sha256 cellar: :any,                 arm64_monterey: "3548edffa8adb1f05375b6f2a7d1e2c88d5d6fb09e04f21a686c772bf4cba6f4"
    sha256 cellar: :any,                 arm64_big_sur:  "4cb3891c48aaacb9df4ed394019d702386b517f12e663f603ebbcd07b666aa5b"
    sha256 cellar: :any,                 monterey:       "dc3e3d174dc3bce66c5a7ba12fdfae4e3ec970ef9464089d89aca77d57f9a094"
    sha256 cellar: :any,                 big_sur:        "b9cc7f1da7c2a57e2295e36acb16be6ec5875673d9fad194a317697bfb3b3689"
    sha256 cellar: :any,                 catalina:       "84536d08909a5927e9b8648539254b86fa6c23ccb421cb8dfc0904ccbc545efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a62275beab23a3e417788604399e118c16f773257be9983f72afca5acea47e7"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
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
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
