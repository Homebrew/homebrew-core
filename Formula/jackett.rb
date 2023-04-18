class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3927.tar.gz"
  sha256 "d383161767e2aa058af38c024ff9966da5da026ab2594c28e491191bfc4f09b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b225b9249746231614085c028d33501966c0fc2ddb1db8ec760d8b56a080883a"
    sha256 cellar: :any,                 arm64_monterey: "5ae2c982a65bd5f43f64a09010de3ee3c971d74330454a94b053096fa6f40fc8"
    sha256 cellar: :any,                 arm64_big_sur:  "f6edd0016758b1899f3e66fe3bc8e7a75e5435366e07995b390e902357e54c74"
    sha256 cellar: :any,                 ventura:        "484be4a0cb4bbbfe9ee2da3b91f8e5ddc371ff8c8e9b42ab6378531646a13510"
    sha256 cellar: :any,                 monterey:       "800e6256359995a90b6a47f8807d253be5b4191b2eb5c13d848f647b42942f72"
    sha256 cellar: :any,                 big_sur:        "cc3c9a9c623da3f68fa08754815cb65eeeff6feab20f3cafa1e8a476d458e028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba9bed6beb38909295480ec6e2d85318a25171cf8b60d3f0e004c2563f1d6e5"
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
