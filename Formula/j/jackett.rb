class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.904.tar.gz"
  sha256 "f74b74b41afa88f338188d567655d2b785310506a6378df7f0223cc3eb1eaabb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "972938843503f104ca4b8a788f84f2b57c86a0f38762ddb0dcedd4889b1d397b"
    sha256 cellar: :any,                 arm64_monterey: "749050a9dc2071ee49fbda50faeaac07d7abf6b3d32c2b09c2b03a0083618ca8"
    sha256 cellar: :any,                 ventura:        "f1942765a51f97d50ec46c608b53983da8f9aa9cb5d6ec137595dd6e9d7f8abd"
    sha256 cellar: :any,                 monterey:       "edea280a01ae9270e0503194f5748adf26681f0ddcebb272b9b68a400398e030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048388e0b272cd1dd500e85843f98d5402927adac929491a827d1f0da10c15d5"
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
