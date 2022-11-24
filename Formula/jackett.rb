class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2285.tar.gz"
  sha256 "67d14b55eb0b3df44ed46f9be1d15ab4dd007b4daf7c9c9dd8d44a96bc1d75f0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "237cf83de9643636724850a12b268db4e9c4dde294f91d37a8385fdea9c90cef"
    sha256 cellar: :any,                 arm64_monterey: "71fd77bb5c615dd36d9011a385d5bd2a1c6577472f75d298c78770bfcd36ff7d"
    sha256 cellar: :any,                 arm64_big_sur:  "7a8bededebe722456e934511d5875bf70d5163ec2bc423b7203877e14f9b5d41"
    sha256 cellar: :any,                 monterey:       "9875587b1f70df483eeaba662b3d11168033517733e93da0db05cbe26f2071c1"
    sha256 cellar: :any,                 big_sur:        "07838e2a664ed23373508fa8f413867a47ec2e88ebf6e7ba3e8d5e14fdf40522"
    sha256 cellar: :any,                 catalina:       "240746ecff57ed047ee60c768be73ce7d5a618c8a20b42ece69f654cf37db4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4cbf443a998b656c04442193945831d0237bd5969497821b8394bd68f64ef17"
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
