class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.207.tar.gz"
  sha256 "2380a60eaee5492c93a447ff3aa260fb12dfc7fbbbf30a4066508a8e7c8fbc08"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "92bbe8478ea81955b6c72247d9da7b0a2e86248dc40c6deb501011b934b05b5b"
    sha256 cellar: :any,                 arm64_monterey: "a529b938bb89a7405b15e243f05a20a8333bd2a7960427b60185dfc35eedeb03"
    sha256 cellar: :any,                 arm64_big_sur:  "2f76389c998fcc49b9b0c3543adc93008956fe43ba6ee2ab1664fa466812bf36"
    sha256 cellar: :any,                 ventura:        "34134fd6e6dc0ad9b07daad057a6c412e9fb6bb9dae3f855475c70ca9108c47e"
    sha256 cellar: :any,                 monterey:       "9bd8615d25c289fbfb2da4162062eb88e340a1495f28517c51d111e600d6f462"
    sha256 cellar: :any,                 big_sur:        "a593359b31e61da28d187dcfd51fa3c969af4ae49a3c12d8c3f5181db53cb8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75822c9a419887c362d6d5cc6b54d540a524b5cbd5e6810f0c8136dfc37696f"
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
