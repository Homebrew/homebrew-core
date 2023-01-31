class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2782.tar.gz"
  sha256 "90fd36057c92e00bb25c7f71ad85c3718cc335f1291e064f53c7eb6442c8d4c7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5af510395bbb30fff532baf115f2e7d1db49cda7de594b40a8287c2336686ef2"
    sha256 cellar: :any,                 arm64_monterey: "9741db72b6b6fc9a45241cec32644813bf7efa00b9b33034032d94feaea83e5e"
    sha256 cellar: :any,                 arm64_big_sur:  "cf039ea01bc0b6db5b73354870ffdc455c61d2cf93a70710ff4b590222c91a2c"
    sha256 cellar: :any,                 ventura:        "d6ab1b25b44925e395508452d747bd366d9fb5902f05463c23cab012afbdc3ed"
    sha256 cellar: :any,                 monterey:       "00beedc1e3ea80ab2d977f0add41486b37d5f15f0c5488f63d1277d9b2c36cb1"
    sha256 cellar: :any,                 big_sur:        "ba2a5e23f8eabdea46a08fe07c5a4ab0e73859ec0ccb0239a596bb42613cb9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d97ffa92a8f5eaa74b0e73cc36786995dfa56a605e63e734f35b710ccefd60"
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
