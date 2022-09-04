class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1830.tar.gz"
  sha256 "9a8e1055d73452cd4d28a38e5c2dc853db2c831f70a3a510f3a82fb26333bcb5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "760edabf97277f2ab01e84475afc0cb5ba64108511f7c008acbd9a1bba5747cd"
    sha256 cellar: :any,                 arm64_big_sur:  "17ef15625f692bc6eabb270d660334633134529f1dfbfe87ff72f9eb0a8aad30"
    sha256 cellar: :any,                 monterey:       "676c3fe956b6c0722255144cd0c274918ef2ecc84f258bb93656e3e54b9f36c9"
    sha256 cellar: :any,                 big_sur:        "4f24b17bf319e0014e1d66cf6c6b719ca78248a7605f127a92c0668d81ff57bc"
    sha256 cellar: :any,                 catalina:       "7c529eb1815d22515ac85cfb56fd0ca174b2b6aa0a51619490b5d09af495696f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e66db72c0ed4929c7eedc1c1e87cbe0199744b179ce05a04ae49f32beaeba692"
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
