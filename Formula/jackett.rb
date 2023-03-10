class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3579.tar.gz"
  sha256 "8216a6091bb47fc60a150e6497bb714ce413a45bbd6b8ae189566433bad0b8f9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed4617507c4568199ba186766e5d0c50e83a94481eb521d8a35baaaa4e866589"
    sha256 cellar: :any,                 arm64_monterey: "336a6c5720dcf599d42d662043b51b587b6774a8516bf281fdff3e9dd18c3477"
    sha256 cellar: :any,                 arm64_big_sur:  "471653a5af9a4250bf17d1826ed30e658a1d286dc545dec8c8082f8cc352ec2a"
    sha256 cellar: :any,                 ventura:        "34e28f5e17ba708fb0669d9ffbb7e402c166649139ac4ae39de30639e9cf9b3a"
    sha256 cellar: :any,                 monterey:       "7f50c8f8da19086191d9409446f2274848ccec9f94e2ec54b0cc32cd61859b1c"
    sha256 cellar: :any,                 big_sur:        "f3accd6905fad4630863041307dacf9cfb88106af792bb9ad7d870cee58cfbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c580330852da4c3cc95a282a800467f4f636ebfe0e3ecd328925f82925bb49"
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
