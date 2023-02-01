class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2814.tar.gz"
  sha256 "d1040ecfb46e7c9079e25c0c24c4771b778d93f833d35ef8cc227d10df722692"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "79e5cb266a12bc733e40067e30b62d078dcea76c357f0bc2a8a598d82b95cfca"
    sha256 cellar: :any,                 arm64_monterey: "0ca403e8d1c03bf092247cd9a0473788185afac9d96ddd926384f807ad643cbc"
    sha256 cellar: :any,                 arm64_big_sur:  "1e08867ba4592da483f47fe08b3cc8299731187b06381e0742c885527af2178e"
    sha256 cellar: :any,                 ventura:        "5df59d85da089ee7a197bb0418c705e904b4ea6e54b15893f8672f293630525e"
    sha256 cellar: :any,                 monterey:       "0138d092f8f7c6db7b140878d02760596899934694d9942c8ac848ff87c8ae12"
    sha256 cellar: :any,                 big_sur:        "525f937031ee72acf7116f6aaf21d31311db7fb92f92a5116f0d9c9581907c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518d3d43dcf3e913517642d61ff04e978db1e5dadd0f88c3cd69a3642f527154"
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
