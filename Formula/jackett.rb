class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3682.tar.gz"
  sha256 "2e8fc64cefbcaf4e9ea006f6cc8a983bd27f6b555a553ea2e64135a8a5c0bec1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b049a7ff03a95014847838afa4ed2b37e15b3ddfa55d926044cc4a3253796bd5"
    sha256 cellar: :any,                 arm64_monterey: "35ecb89a0e8bae67d1e08a36dfc35df3bb9a8f8de95020c16ac6bbde3f5f4905"
    sha256 cellar: :any,                 arm64_big_sur:  "13e1301abc6c8d37e425c5d36fcac90fa449039e4dd9d012208a4843c979efe0"
    sha256 cellar: :any,                 ventura:        "d7a1658d146fefad9e1fe1ecd93b4be27451e0d72f51215c59889213d4ff9e0e"
    sha256 cellar: :any,                 monterey:       "2caf9b05b1cb566068d3aebde4ddd46077778565f4dfc4e9a23ea1ad4ee5027f"
    sha256 cellar: :any,                 big_sur:        "60e462651c2577d1331a13fa4f71d95d817de120229533ae6bddbc4998a3ea5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fce2e72b62726e1d308d197e2e22258a9b8acf9e815eb10810d2cc305b35583"
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
