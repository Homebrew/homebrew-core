class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1197.tar.gz"
  sha256 "550d07154ebf97cdb69b6f6063585b4a5510237dbc15a2f0901c8e8f43f520a4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "239a42e0c44326191e8d8d54c63e1370a6586aa0cd6672ab4927e8081840cb7a"
    sha256 cellar: :any,                 arm64_big_sur:  "7a541efd4ffe4e7ae6a5498174db05658a86c1077a7082fed473966ca5086c57"
    sha256 cellar: :any,                 monterey:       "9d67cd9306676aa997b87e2ff10acd35438dd360fe224eb261fff9cb6f163600"
    sha256 cellar: :any,                 big_sur:        "ed14fbc971c241d865adb0c54b3f839271ed6baa381aa81a8bf5616fd0bb660f"
    sha256 cellar: :any,                 catalina:       "a67e12df30b40f0b129684596eb3115b5e47f9ce2d83a77e7a2839f90625cf12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bcb75b4c1129f6bc6c49ff8672d79beaa6a5b766d3077323415ca3fff31819a"
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
