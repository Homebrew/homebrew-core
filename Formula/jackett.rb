class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1078.tar.gz"
  sha256 "65eb6a04c2e5253296e6226c2ab49c4c474cf70f2d1ce27013b1cffcbf208a19"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f955b81261d7d4ad28aa03b30b84adfe473c81791238a5cee0c768a9d7751e05"
    sha256 cellar: :any,                 arm64_big_sur:  "e9e3a8a393dcfb218fc213db4ee62b6ea269e1070891b4bc6f6bd5165fff0499"
    sha256 cellar: :any,                 monterey:       "ead68cc2336aa5fb411f4f917001c34dd4641c73077ed6c99a6d1c2bc58f038f"
    sha256 cellar: :any,                 big_sur:        "76fbecd5c7288a2c71f45ef7f70853c9317979e824df0cfd24703856dff7ddd7"
    sha256 cellar: :any,                 catalina:       "8056687a50a9a84b9e7c8adc25b832951880cd8f082834047aca38958d21ec16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64fc5c43f3b333610bd4747aabd51a01a6b8aa29f09cf1dcbfd8588003f24642"
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
