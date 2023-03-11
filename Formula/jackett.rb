class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3583.tar.gz"
  sha256 "92b2d5aee4b126593af93a78e78bd1daf3818be2775d697e331f0c39da199aa3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2292210928aee43748f393732c0da40a3755f0590a55f12bb55ba9e6c46d674c"
    sha256 cellar: :any,                 arm64_monterey: "b059c4de388862303b9965f73d93abfd37a19cb71151833013192e06728e3899"
    sha256 cellar: :any,                 arm64_big_sur:  "9ee1c83c2cbf3f435513ff709e6a908d85a1ffa4b3adee51be7b187dfc89f28b"
    sha256 cellar: :any,                 ventura:        "cf799e7ca5cf5e38031d25ba8eff469a617ab46a68aff13ac611098fcee340e2"
    sha256 cellar: :any,                 monterey:       "fc61d2a35df1ff5a77d91a11fbf2dfd0f93768466c5981118e789c9e8073a7a2"
    sha256 cellar: :any,                 big_sur:        "33ec648a700e04ec743640d06cc373364c18b5be2fb83de8aa8550925d409425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66767532460530740c8e00168e8254a8b5e569579012190571c09b031cdeca40"
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
