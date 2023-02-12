class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3063.tar.gz"
  sha256 "68c6cca6b3edecb70f3d17c4cda798831dccf99eab5638122a0489a6f4134f8d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "becf9582e4cd78e5262310af18034763422e93c08327a3a0c644c81d03d7d151"
    sha256 cellar: :any,                 arm64_monterey: "7034b75b0e2ae0f4b3bb60b5fbe6ed02b369cb0582574837a8bc85b7b8e19220"
    sha256 cellar: :any,                 arm64_big_sur:  "fb0890297e29a3faea2846e28d9988c8d2f3b0f1ff8cac76d0ff6f601c4b7de8"
    sha256 cellar: :any,                 ventura:        "ee9f9fd6c74833025019ee676e8d83a040baccdd7cdeba3e1fc1c3015a0ed1d8"
    sha256 cellar: :any,                 monterey:       "c870de8522c3ca3e8f1f6cebb2071838454224633954e0c401204fe5c4a49968"
    sha256 cellar: :any,                 big_sur:        "f52fc8711f60466b0bc7f746bd7ad4d353c40c72fa2f8f2b839f9e95edd8852f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c565dd8fea1706ab2df89b9c32d31d31b52846763016b72a6eec7d1049601f"
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
