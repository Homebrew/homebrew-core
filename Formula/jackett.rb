class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2617.tar.gz"
  sha256 "0e80127df8d0bda911c4626954855fe31db42dec2df1bb2afe6d36221c51e340"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df2ed85b39cd65ffd4783e529e959251931aa9a410855f36866bc456c6b80cab"
    sha256 cellar: :any,                 arm64_monterey: "ecd608317bf937a1614323d5f70f0b826681ed7d9af10524a83434cfe7651ff1"
    sha256 cellar: :any,                 arm64_big_sur:  "e72e12b63f57f0a10638d0a257c8311d524a96c8a31b58981ea75d161c5e0cc7"
    sha256 cellar: :any,                 ventura:        "27999bb220d4ea4ba03588e8236a383dd2650f906da875b9f93e7b7568762be9"
    sha256 cellar: :any,                 monterey:       "2edd1d0e31c71abec3dcd1f165d08595ee49991e58c4d6d593e7aeb72eeccc5f"
    sha256 cellar: :any,                 big_sur:        "6b355bd88d8c95bc7bc9b0075696c594658f7ccd4134e53eb9e260f849dbb4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dc400efe8139ba9eea9ef931c0bb3aa8003a1eb752db1a17dfa689ac5a65132"
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
