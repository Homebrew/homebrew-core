class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1918.tar.gz"
  sha256 "fe98055659ce9f00f7f80ad1f450ae74503b1f9bda0f83c00eb6f13669e12fcd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a5589c399990b20a5b050a531a5f5aab5283a7b99814966e555ea6c975a338e"
    sha256 cellar: :any,                 arm64_big_sur:  "5268e385cdfd5444b563ae2dbc059b07681d04980eeab5d6787c77adb7536166"
    sha256 cellar: :any,                 monterey:       "c1aeb10f60e2120e51da07a6f6079996b023660b52effa81df9b5efab17260ab"
    sha256 cellar: :any,                 big_sur:        "b02d751f21162700280f9f543a32261eb59847bb9de5f1cbb23b5b92e721fbd5"
    sha256 cellar: :any,                 catalina:       "5a688b470a93732f8c07f1dd9c10a965f27b0b4dba8b55c2aefdd9e607172d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "737f3af9ab7d0993b718ef18acb19de5605b2c6a67b989551da64dba8ad45265"
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
