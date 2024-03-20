class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2103.tar.gz"
  sha256 "17e275956eb67d574bca011fb00056f5934934afeaf09cf2b2cd1a935f251673"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0aba1511d320289270714325a3e4c51361b5a70d677e495faed5ccd65bdc042e"
    sha256 cellar: :any,                 arm64_monterey: "9b2dc133f9901f2209e8c87dd0ae5b0445262a821cbc928de6179c9a1d4d52a8"
    sha256 cellar: :any,                 ventura:        "0492977d16fa4f7a27ec4deb309d1151d86014c55f2664f1901150f9fa0d76b8"
    sha256 cellar: :any,                 monterey:       "f502688f22d6998670c6975fb45eceac06ab577dc9af390d15f3c87b8ee4951f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ff94bdbaece581a8a672468c79487d9e8eb20ecbf1e843c67093c380134b0f"
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
