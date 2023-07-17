class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.484.tar.gz"
  sha256 "878abbf8747b74cdc8def265c37fba9fc6ffcf2556dbae88b3f7a4a7b4101370"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b4267657f71d46471eaa056f992c4e226172f51b56f7cf7a4b3f7a5055837d5"
    sha256 cellar: :any,                 arm64_monterey: "f50ff589cd839911d2744ee8c9d581e15aba495a17b9a88243998f5f9e3c80a2"
    sha256 cellar: :any,                 arm64_big_sur:  "6859ae07e1c439087760615c465b0bcad0db0f0ba961aac1b383b002eb2628cd"
    sha256 cellar: :any,                 ventura:        "fa0e43a3c5c48ac958652b0ba1939cd368735db6ace0eebdc9a5cd958a4f6cb2"
    sha256 cellar: :any,                 monterey:       "35b34697fb9483b0ee4d236e4cc1fae33b03630aad5759fcd6b3b066bb6b730c"
    sha256 cellar: :any,                 big_sur:        "43d055f0b526a3573e24c51c7b9066130f56c721a1c4f7d59ea622c6f7d27d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ee8d4dd121c3a81c97f26e3270ac63c034d645397ac07e0b6dbc8bcb1d68bc"
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
