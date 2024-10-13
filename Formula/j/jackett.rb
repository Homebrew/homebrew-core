class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.779.tar.gz"
  sha256 "04d4016d80d1ec6f9af17e4099a01608f497e6d769db13cb948bdfc37477aedc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff83f675d91ce35b53359660f6808798ae289c9034d678a2096a8b231878efb0"
    sha256 cellar: :any,                 arm64_sonoma:  "40eb85c39d540f8c01532a61a07538112e9f776b896ebf74b8d160b22a1b8c18"
    sha256 cellar: :any,                 arm64_ventura: "0919c6bd73ba790d5fec2d1825523824bcc2a0109cda8c8da5ffbde2f0e259af"
    sha256 cellar: :any,                 sonoma:        "65ce3908436cd701ae4dd2b75d66a2fac4c24677e32992d87d0343d2a6b12f3c"
    sha256 cellar: :any,                 ventura:       "4e3dfd98a20a3d46a18f09a460345cbbc072b45c026f18f94fbd54a5c1669791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280c9781182a5ed3d9c74223c25b8343133081cbee749dc4b418cb5ac8fbf940"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
