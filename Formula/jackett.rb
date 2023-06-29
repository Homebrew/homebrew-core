class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.341.tar.gz"
  sha256 "ff27dbdd76b389e1183ac9be6f7b11355a799b6232dbb5a708905755eabf1600"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ba36630648aa458950eb22fa4932a83bb1215f29e7b7adc048196270df5529c"
    sha256 cellar: :any,                 arm64_monterey: "b910d2acb04cf3bd5d3d89fecf5dc972bcf93e01f8269de86fc04d60419c4b97"
    sha256 cellar: :any,                 arm64_big_sur:  "ce18c2e9e23b1cebcb48b22ab60d2b95cb5680e78a40a9ad037ea3c7455ca3bb"
    sha256 cellar: :any,                 ventura:        "156dc626a8363a7681c48769ab305dd77b4bebcec0870fcf9351ddbdbfc3b33f"
    sha256 cellar: :any,                 monterey:       "08d2ddcb45436a77b2887234331370270bb04b3e3e8e31feb8e8cc50932349cb"
    sha256 cellar: :any,                 big_sur:        "fc21d7118ec57b6529779032b9bc2141cf3309d1f14d2dc69b2803ac628f947b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c682e1699e12c6f7ae080b0cc83c6c526d6b8a1577dbd037ea77262ecc4892"
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
