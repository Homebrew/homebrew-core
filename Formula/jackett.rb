class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1687.tar.gz"
  sha256 "d88e7688652f9eb4ecb2eacc8aa895055e87698bc56051494dcc7591ceee94fc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13cb52007c44e8b0cc4a15a79d06f5a4e9a0033b8a37262f373e2fc033eaa970"
    sha256 cellar: :any,                 arm64_big_sur:  "5fc30f1076b4cafc550f91d19dc008e0024f35e92f4dabc7475a926517c34375"
    sha256 cellar: :any,                 monterey:       "6da6cae24a979063c95e028392044b479835a6252f6a3e23709b9ba83f9aa64f"
    sha256 cellar: :any,                 big_sur:        "67cc0cca88cf9a90fa5a565ae131ade71983a7da696be1f565375cf8e4790ad5"
    sha256 cellar: :any,                 catalina:       "485f2f408bed0bd97838d9548188211e986c4f8a99bc3e5e3268a008a777a788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "648d45a8fcad956968b68dab8dc8b077986bcd79012e2b2bd39dbc176bdf1526"
  end

  depends_on "dotnet"

  def install
    cd "src" do
      os = OS.mac? ? "osx" : OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      args = %W[
        --configuration Release
        --framework net#{Formula["dotnet"].version.major_minor}
        --output #{libexec}
        --runtime #{os}-#{arch}
        --no-self-contained
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]

      system "dotnet", "publish", "Jackett.Server", *args
    end

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}"
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
    sleep 10

    begin
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
