class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3366.tar.gz"
  sha256 "d4487a4adff57ea7b2d792232297cbd998e5588a988c1ed1a7e981914f5b32d2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2435701e4463b46524d978163b82ff0561d1f9a153fa58dc23b1c7b6873a7c3e"
    sha256 cellar: :any,                 arm64_monterey: "4dc209b4887a262ea8ecc00181b93a2bf3c36a4a1407ae55526cf7c4d16ff255"
    sha256 cellar: :any,                 arm64_big_sur:  "28ef5d3d68c67c792cc64eeca49925c6bd1e56143026b2e769254e0df3fe8c39"
    sha256 cellar: :any,                 ventura:        "65ce7827259ce1aabcd9e52e0a89c9ad4196c9223cb5abf67b2367dd9bd3b188"
    sha256 cellar: :any,                 monterey:       "7d982c95ae356d332a0c116605930957b86df4b42c5290e1727a380a32327b95"
    sha256 cellar: :any,                 big_sur:        "81c95a557d4b7fd603bf383668670b6dc4cf0f0f40a0775dbef95d604c4f6f11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5411183d9aaef84cf9e6ec8a26f1d472b2174acb9718dbbbb273e910069e7566"
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
