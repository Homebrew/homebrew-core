class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2620.tar.gz"
  sha256 "03a39cbd15a8842d2d23d65ced007170b78a5178e487704f7f1d52bca4df733c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57cb9bb409a5d87bce03e8463f53ad9ab0a1c05887613924815e003ff96b9133"
    sha256 cellar: :any,                 arm64_monterey: "4e9232f8ce5495dc379d3ed943b98bbec49549fe47f004f98675ae8a86aa1f2c"
    sha256 cellar: :any,                 arm64_big_sur:  "f9566dae919ff56be73663c40f3bc8e912dd3099c9085b7587e87eb2bf2faa53"
    sha256 cellar: :any,                 ventura:        "723f26e00c17c9ec541634162537c9e4716f6da1d912168394650c13671436d6"
    sha256 cellar: :any,                 monterey:       "33a0fc18e5708f1e8809b23709d924eb1c8fe8f7d14b5ef0016b87ac429a3936"
    sha256 cellar: :any,                 big_sur:        "209b26f1c15f9387034e3d374c712ecc4fa0faad81340f9d73c5ccf435d1356b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f33b375a4b12d1cc9a999ed5a5b9ddb619e1d4d15dbbc3ba85c70ec4c6a388"
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
