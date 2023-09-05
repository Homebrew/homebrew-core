class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.741.tar.gz"
  sha256 "ececd0486e1b3e60de5b602732291b5dc801184b482e18911bfa8467692c98c8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d31771fb21bbf2eac9ece98e6c929717936bdea1121b5b8efcd3ad894e727bf1"
    sha256 cellar: :any,                 arm64_monterey: "57b3ceb4bf26335d0f784fa8e386eb1eb055b02b822caaf25bb875bc6c7e30d2"
    sha256 cellar: :any,                 arm64_big_sur:  "735e59a29b6147613b08f7dbc91be5557c450143dc92d5a409703ef0cf8912d2"
    sha256 cellar: :any,                 ventura:        "b12356e761b0be987690554bf5bed26bd7228ce9cc71babde2f9900a07dbe41a"
    sha256 cellar: :any,                 monterey:       "8b120de36c0fdea9045c273ff73375b90c70a67f5bb053ffef08c44159194b8b"
    sha256 cellar: :any,                 big_sur:        "b32efa27593644cc86db9a2b50f6b708fc512832171268392b828544c6f6175a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "154fc46b9f6f031cd2c09e53cf0d875360dfd86c4c2d8d3fa165bc57d60181ff"
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
