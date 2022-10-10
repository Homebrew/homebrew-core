class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2095.tar.gz"
  sha256 "c820b7ce83a4ae3eaea37d8d99dda5932caa325b50e330b74305040fd4be9e88"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70c06cff9ea4f65200a0d29c0702ee428aef75dd1038ffad586486b9616ff890"
    sha256 cellar: :any,                 arm64_big_sur:  "6416fe935fb8bf3b24f26761a76f725f9fe55b28e6fce706a898edf70132ff16"
    sha256 cellar: :any,                 monterey:       "c2ef9bd9dc1c0dff8719e69e44788025cbae6855cfb668cb3979f8ae4f0cb751"
    sha256 cellar: :any,                 big_sur:        "3323aa5fad72c685fe6d6e0c19c813434861385b2434a1f2d617f3b37859d21c"
    sha256 cellar: :any,                 catalina:       "c4bd4d74287058e6c131a667ee6b191a9f93c2a10a819de128afcc50159d5fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3ed480cf81929deea18378e04b91b8a236c6b68f5376de1a2e3a4d5aa037ff"
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
