class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3920.tar.gz"
  sha256 "a89a42538a0530df6df8f1eff2dbb711467507927f702e4e4d5e9fb372e05b7f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cbf21fe87ec8ac83566b5180fbb8ed9e34feb8c86c6c5d2a2e79d14239aa1507"
    sha256 cellar: :any,                 arm64_monterey: "27bf30bc1b20a7d03148be3aac93cdef859184dbc77dab54939c5cf4e354d430"
    sha256 cellar: :any,                 arm64_big_sur:  "a5cc51141b3ddf76d7894eba610c59a834fc09641b08ab9c329f30a0fdf67c1e"
    sha256 cellar: :any,                 ventura:        "66f80abc8d33bf6c3aa948796b731795f3369bb78a9065619871effa2717d6b0"
    sha256 cellar: :any,                 monterey:       "7ce83372142ecb119afda66f1501c444e0f816523977050cdf92939c1ccefb61"
    sha256 cellar: :any,                 big_sur:        "ee048f582627d929addf5aa62f8c5ec2ecb1b45aade96d62feb253f54032fe0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7579fde8b0dea053b1d9dfa5f3825c3659c3992101ecc3afc3ed08b14252a13"
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
