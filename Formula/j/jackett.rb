class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.664.tar.gz"
  sha256 "71a38db3e2a0357fc3d45191ff2c1f837c2930940423c03ce1bade1bbee4c04e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "f66f3f623d73401bf452be63b32b66f25d29c6203a7f5deb5d0f6f1e66ba1a50"
    sha256 cellar: :any,                 arm64_ventura: "883372381e209a8f5d55b20559cf71bf6867e18964469cd81827614b0f5dde50"
    sha256 cellar: :any,                 sonoma:        "fdc69d63eeb8910c1ef522aaf9c7cbce75c8d9689605fd65af771a4945612758"
    sha256 cellar: :any,                 ventura:       "64f132e1173b1b07eaaae98423e60e0886709e4d76ea6d2c38d23313f1af0308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6503bc9fbf983a02dc2384cfbcdf55befea72a06f37949060b819017dd62bcf0"
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
