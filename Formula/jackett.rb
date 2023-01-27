class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2721.tar.gz"
  sha256 "b04af786d10e6cacde9ddc56c76033b82f0348151d1854051158038f2733dfd7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0e89c5d77c0922a72b401b0a052768641564e5f5544bca8cdcc850730836e58"
    sha256 cellar: :any,                 arm64_monterey: "22369960aa22f19115c05c03da7009dc7cf292af3bf2892488b2457aaeb5e19c"
    sha256 cellar: :any,                 arm64_big_sur:  "fdb87edac2f7f1d9dd84c0e149b50d62435954a5799c7460d409aa540e5d25ce"
    sha256 cellar: :any,                 ventura:        "9839ac1911fd5d709fe7445180c871a9587f6f24ed52d3cbaec309e998649582"
    sha256 cellar: :any,                 monterey:       "429e99aa18a3b7d8785ff17c49200c6b5f3c52bf3f8bd508498e41da31d3f304"
    sha256 cellar: :any,                 big_sur:        "467d2661960cf2c1b88c1187866bcb70081eaa947799e291032e8e681f71fe38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43103dbbfc13e90edd0aad4f095bb9ded794db1a62f2f85c08aee7865bbba8ad"
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
