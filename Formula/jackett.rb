class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2082.tar.gz"
  sha256 "7941dcf4c3d02e06a0c1834c5b86da7c92d2fa9cd71ea0e52b270e929695afd0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0375bfc32ed5707ec518abb73b955a4e4314a517e6dde8bdba713487bc75c305"
    sha256 cellar: :any,                 arm64_big_sur:  "40a447a07133e8b9ed1a92e13dbc30e4df29d647160ccfd3f054a487f634ff39"
    sha256 cellar: :any,                 monterey:       "1e617fcbda709c7218e958150d43efc39485a9e12a17bf99723a0c98945a459a"
    sha256 cellar: :any,                 big_sur:        "ec637b25a3a44ac508f4f157afa760b8c53a107ec97deb4bb5ef4c9aed92ad6d"
    sha256 cellar: :any,                 catalina:       "eb443ab6d99abfea3e9e7626a49db301edfebf8d9b7ecc166271de247f9c02f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6cbc54fd5af8effdb9dbf21198daec26b8f442e5790c4ae5228f6035698283"
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
