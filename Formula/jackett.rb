class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2417.tar.gz"
  sha256 "5fd037eab35ac8be37f1bc6f8b0eeeb9c7459fc81e8ae3aacac3222f4449c2ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4b835a801c8e0475eb6d48e6892a679d2e50b42c9c4a878a94a77a1cb622831"
    sha256 cellar: :any,                 arm64_monterey: "88531193450ff8048df3b1257c8cec15d122229a9d25ded8a8b2b08483c20c76"
    sha256 cellar: :any,                 arm64_big_sur:  "9591ff33d906600dbcbaae020e76c91afa0bbdf4ca99fc8758b2404a9a961443"
    sha256 cellar: :any,                 ventura:        "f53aae7896792e43827db2e46a2b1d6d994a6bd2dcd948ffa8ee7cd536230487"
    sha256 cellar: :any,                 monterey:       "de8ed0881332efb0eed7f9db12db319a0efbf4a43695b68d729a679205a2f7b4"
    sha256 cellar: :any,                 big_sur:        "007e4133afbb84c6a0dd7cfdcb7d2ae06ecdc16880f1761b3208a7cc41955fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122ffffdde84f1bd4fd9d10e93084cc58736ca7bb87d79ac377fa38e02fae68e"
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
