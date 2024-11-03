class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.878.tar.gz"
  sha256 "7f630982785dbfec1a68d047988492e99c95c55bc426f6a5581b4022a0d35504"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58fdee28a3167bfe2a0e1285ada0b347a1bb2963b91c9f16d7fce805f23039a3"
    sha256 cellar: :any,                 arm64_sonoma:  "ee2d883d72a7fef0b010b327cecbf38669f65c9b44418b86daea6fa81e15601c"
    sha256 cellar: :any,                 arm64_ventura: "2ea758536cc7a8a48f915f8be1d32dc238ea03361a2ef63b4e7708f492a39afa"
    sha256 cellar: :any,                 sonoma:        "35497941844c9f93cae8897967e161da4e211a70e222bf7a7d7f3c30cd3d39fd"
    sha256 cellar: :any,                 ventura:       "588df8002314e43776f0ea6c97ea234bbfe4f40d72152088d26e19c2824f9521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f924caaec9d2b2310b92865dc114c959b7fe0e04df227c1c77241c9e586fa369"
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
