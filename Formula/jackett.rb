class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1197.tar.gz"
  sha256 "550d07154ebf97cdb69b6f6063585b4a5510237dbc15a2f0901c8e8f43f520a4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6e4a41481e26272a68e028ce223b6bfbc0b1f33a45470ebca4b5f914c79deede"
    sha256 cellar: :any,                 arm64_big_sur:  "105031a12ddca9fa9e3c535b518271c945471a419b4eee9b5902d9e25bbc55e1"
    sha256 cellar: :any,                 monterey:       "afbee5b6ecdeb1f1a50ffdbc099bc4c8c1473d6f929c1b6658c24a5c88d2a6f4"
    sha256 cellar: :any,                 big_sur:        "9a66c09c7e2fc164791da6022fa5fc610db0a99a5e5c3297e3f467bbe8a42a90"
    sha256 cellar: :any,                 catalina:       "f352348b07996359699b58f71d37bc9ba4cd1ae4cd04c0522fa84ff9a77bbe57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e816e4fc52368c71d744ce00c5de8dee34c0e6fece54081c7f00dea28335d213"
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
