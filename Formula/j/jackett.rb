class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1461.tar.gz"
  sha256 "5082a6dea22ce1c6a183ef03e9ec064ccd22926a51d8f881428b5c4a857c54ba"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e713d05bd1d106aa99961eb68936c8ee822f39215502e51bcc7990b3043208f"
    sha256 cellar: :any,                 arm64_monterey: "f310d2a2a1f8ce2fc5b14185fb322385e9ae2e2c3a97172b4d0921a7374049b9"
    sha256 cellar: :any,                 ventura:        "566b066bed8f03eaf9b42dfeafeb3628df7862112e2faaacc5cf98b7ded03775"
    sha256 cellar: :any,                 monterey:       "2d5d30990bac0efdffa1d88dc288e4fc2c922190812924efb492fbe46bdd5534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb09b5f278e3fba51f74bbf82731d6ce1a7cab3211b5d34ab73fee41d601ee54"
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
