class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2697.tar.gz"
  sha256 "639200959d6cf93699588ec4a49fcee4dfe4e8173917ef79308a45e97d79fcb2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7ecf69bb45c7683e988a4181dd8cb834868cd9f1e4fef8bbabe3b9685cf215e"
    sha256 cellar: :any,                 arm64_monterey: "283ccb3d4a004ac25e590ad25631792c9123cf6f571eb52e72fa705eee02c413"
    sha256 cellar: :any,                 arm64_big_sur:  "d375f2edfb2239025a1ed04c74dad8010b1200f4785bf205b585a3aa9532211c"
    sha256 cellar: :any,                 ventura:        "9a4c423d8d7d306a9e6d4adf615dd6914756bbeb393aab6593979f50660bfac6"
    sha256 cellar: :any,                 monterey:       "57a286b5f9113a711a5993ab8521174b19a26420d580b63cd277942c911e40aa"
    sha256 cellar: :any,                 big_sur:        "423f15d9beb76524398b5d56142e9d8b8d4745c9cac43ea870f42365d386af6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814afe18108048d8d259226fe2ac6c0a0aa2a88fb456ca03b4f9f36e291d32b2"
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
