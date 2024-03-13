class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2015.tar.gz"
  sha256 "caa7f5f4e4fcba2f901d7d007254799f141247f228979b6f56ecb26fe0eea3b1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "462036bad1440e0d6fd940a5fd56d4da9ffe37219913349d31d4d2a98faccd6d"
    sha256 cellar: :any,                 arm64_monterey: "ef2b36b4c4ecdba30b96447f6f73578b441dd7fd3b01230fdd0d92f9e2dfc0b7"
    sha256 cellar: :any,                 ventura:        "dc308baeaf128ed9c6f83e46f7f7b9c936e1d71876779678060655acfda28941"
    sha256 cellar: :any,                 monterey:       "124ba8ca760f59576297651aed4190d037c5fdce75ac24fd908eb38c66f19953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a77e27ab93516449d9cd92e0fd74d3a860c7f3974890d4639e54d7a16a34b1"
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
