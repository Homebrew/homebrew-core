class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2163.tar.gz"
  sha256 "082ee9fefa1cf4b7a3eb14ba2c81046343be271037bcbd9a12d7c7baf74259c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "036ae1d20a5c7b1ae74f29cf4983b52aa5622102a9cc9a74282eb22955a1cacd"
    sha256 cellar: :any,                 arm64_big_sur:  "21ffe98f99255c2f7540ecea80cbdcc43be7956bef9f0afc2da6c0ec6b6cd1c1"
    sha256 cellar: :any,                 monterey:       "9bb413728f40b914679c776cba19fbd8e1ffeaf34d5b40f00f35c66270ddf1bd"
    sha256 cellar: :any,                 big_sur:        "e9352ef985960dec86de4302e347097694465a48f2b72c096824f772a7153676"
    sha256 cellar: :any,                 catalina:       "a22306052be42906b11c7e4f84c6a3230a78d438f356f00aff9c0b628791f93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d48528f7fe3c06f34ddfc2159c8a0015f939cd4978bcbb2d8a583de85cf5ba"
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
