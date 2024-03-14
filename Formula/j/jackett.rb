class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2025.tar.gz"
  sha256 "bf44057bac7f8191c543d7bc3368bdc3e8416d763cdf491eec676ba9994681ae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4922af43dd5a4922ddd0adf2f40a7ea22b59bf59e30041cc75164c7e89da1bcf"
    sha256 cellar: :any,                 arm64_monterey: "83fd491fc3bfd2641db2362ee1095980a483898f5e632e040a6749e3f5e263f5"
    sha256 cellar: :any,                 ventura:        "9a03b675c0b168d76a6864570379a0e029358a12e3b6a65925a2d18f721fd33e"
    sha256 cellar: :any,                 monterey:       "3f688878a30b8a103462f8327fcf30a8fe422d2c9063528f8af05a9087f332fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a26975a0be046705334f2f255a9a8b6049a90c0ce7c1cdbd4c41e35e6930970"
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
