class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.747.tar.gz"
  sha256 "0a6d17c9701c890f7cdcb55460e12c0611a438fbc82735fb5b399b66d8344383"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6da8939daed838fac8b1bd0365a49d982d1fb12c1b7bb677c8e617ef3dad2067"
    sha256 cellar: :any,                 arm64_monterey: "29d1f27266d73ba577af2567044a982e9519b8bd56de787a1e4a38884724f0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "a62ff50b5c00176a1a374855c609fe0ebe12cb42e99679f018cc6fcdee1e3b18"
    sha256 cellar: :any,                 ventura:        "f65d6b9d2f0d5baef674cb2b5bc532e8c1350a7532856d184a7d92939d39fb92"
    sha256 cellar: :any,                 monterey:       "1e351d1ae133ad641081fdb957133c499f6cebdf773eed6f44d7d7ad79e2a13e"
    sha256 cellar: :any,                 big_sur:        "a57c62217891d4ea29b4d01257bea9d7ee31de8ffcf84d66ab56cce71eeb1b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d8a5d86073c6a2223a091d5f6c78b9efbc2ce8fa6e8d2f85d1f24aaff6cd0dc"
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
