class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.664.tar.gz"
  sha256 "71a38db3e2a0357fc3d45191ff2c1f837c2930940423c03ce1bade1bbee4c04e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "4e3370c470fdd6bd851490599adae1fe3e01297e8c5e344430fd58d0e5cd70e3"
    sha256 cellar: :any,                 arm64_ventura: "298eedb2576401d3a68e82e17d7e4f4ebd939dec5c36fc8ecb5515111183f4c7"
    sha256 cellar: :any,                 sonoma:        "0cbdb55bc5e884622842496ca6d40297f51d933a1b561b0c4290b6547453a7a3"
    sha256 cellar: :any,                 ventura:       "afb3fd94a4ab2699c065dec59888c015e0c8d8cf2c38d0aaaec4998f1dafc257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246a318e06504ba4c3b7c59d42f2f95e0c863c15b5cf3f2f9d9f7ecc2b02bbe0"
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
