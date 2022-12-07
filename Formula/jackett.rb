class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2352.tar.gz"
  sha256 "7a7d8152abdc274ceae8a55e88d6b923fa91ef8b8fdf07a46bb2eadf12cdfe12"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b8d7076f597f24f25f29916a418dad15629628ee9302f7422d4472d17d38170"
    sha256 cellar: :any,                 arm64_monterey: "12b40dc85eabfaab1b1d1ced84b3176049d034d36629602798e70c6c35d70716"
    sha256 cellar: :any,                 arm64_big_sur:  "940b15f0be89b0f76c4a1d6b5235f5dbe1f07ef8fc32e913cc6661e7e65b6431"
    sha256 cellar: :any,                 ventura:        "000f50a2b03518a1be7d54aa94b91fc300cf8b19bcfeb23ded30378d43e584ed"
    sha256 cellar: :any,                 monterey:       "4a472a66dd96aadb86971dfe65c4cdb815830ad5586369563a045e8f05d7f69b"
    sha256 cellar: :any,                 big_sur:        "e7adde50b9de04fc8a9c6a684ed37c4249d9737f09033d73cc49a3d324605684"
    sha256 cellar: :any,                 catalina:       "ae951b7e7652b47b3ecfb3f2ecea3680d6aa251d2ad0b82698886f25069575fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94d20f0783e5514db8ea01ff1016f7c42de02067c75a99aefc301230b4eee47"
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

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
