class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2140.tar.gz"
  sha256 "91c793b5a01902225df2da3d7157515e702e2208f2304bfff0c051722772807d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bcdc7abc64b7be16a22d5599312fedb6daa9971801ac056d02edd3631a1258c9"
    sha256 cellar: :any,                 arm64_monterey: "62732df99b5d9e465e4c126c2541d52175e3b84c655c403d6fc4500f37636cc8"
    sha256 cellar: :any,                 ventura:        "c92628a0a0be6f4b96c3a62e5b6131ac051414cab7c1d1da9ca3b7788ea1e008"
    sha256 cellar: :any,                 monterey:       "00bc4c22ea399e154c782d30f2210b06007b96efc285bfe4ec41334dc9ebc54e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8ad536128f3626a12d0d8999aae73c85c758c39337c6a46d94bfebfc78155e"
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
