class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.1281.tar.gz"
  sha256 "20553bdf43499d9251136e20deca2151d28b017c55868da6737664d9d63f61a3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "94ab94f47918b23bcd20eaeb9cda3faabd70bcb0c725262bd23821793539f38c"
    sha256 cellar: :any,                 arm64_big_sur:  "045e04cdf7f4e23355e27fe53594e0c43ca168c29f052384f2de0a6eae298e5c"
    sha256 cellar: :any,                 monterey:       "b404a5ea03c9faf342d7391ee2a49d833f135406fea69752e6026663c7d9992e"
    sha256 cellar: :any,                 big_sur:        "17e401674ffee975bd4145ec2b89b12a66149bb94f365b40efa415c964773254"
    sha256 cellar: :any,                 catalina:       "92c907381a61851342b5dc12183909495423565701e8a98299035441be4dc2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c7a0c2d684d7dd2fbadee7fe861703af7e06a019815e5338f0da98a552b46f"
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
