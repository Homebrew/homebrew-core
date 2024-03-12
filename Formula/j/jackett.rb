class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2011.tar.gz"
  sha256 "ee5daf4037b9840aa0d286c872e2398eee6dad43574d78f17da6582ba9197359"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e08e5cf624c78ce022d385d482091125ca330cba7b3f15fcbfb40dfad0828016"
    sha256 cellar: :any,                 arm64_monterey: "c379a573aaed76f6bcdb724381df760fd17ff2fa9b21dd60e0632502a2d758f5"
    sha256 cellar: :any,                 ventura:        "debe6ced253448792a8e0e128b12123d7428bb10d39290a652791ccd0db9ba02"
    sha256 cellar: :any,                 monterey:       "7fc0354b5a9e6696fe4b0f737f1ecff7f4106293c214494927198bda120e10c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e636bc583efadd4d0a382849bf7d0ed24ad51d84603a76d7a97999dcd1b0a1e2"
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
