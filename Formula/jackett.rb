class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3082.tar.gz"
  sha256 "f7c16a0593a98e152ec99c581295112772b7ff1b64718387b84e380a71247a16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ed77ec0c7c0ec0bcc5d145a2e8732744cec9117efa7e50705597b33d392d269"
    sha256 cellar: :any,                 arm64_monterey: "cda54d3fad92c05a4913b7d829d9d8916af5e04f3a20583fd16f5e769b853a6d"
    sha256 cellar: :any,                 arm64_big_sur:  "562aea8dae7dc12f34ddf7cfb7eb2ee99dbf452fd24e6a27dd8d362d0e090352"
    sha256 cellar: :any,                 ventura:        "67635fb66e7d2fb3b7b045ab4872c5ef45330077aa174326795ff6dd72209396"
    sha256 cellar: :any,                 monterey:       "54e3b5acda50e749174d5da3ff6b0ede5723f40945ec35ece77220a3ce0aa2b5"
    sha256 cellar: :any,                 big_sur:        "72c81b9e847aba21d8ca4bb52613d53a0f4eb43f86301d3015a21447bd864ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f720750c6d4434a9b47df7c639c3308640714cd206a6da296faa0092c0560dd"
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
