class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2142.tar.gz"
  sha256 "cbd82117fc71f9e7b5b20409cf9ed430ed7fd628f995b4726ecabec173a8c024"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2fc0ce8343bccd89f00a745103bbd9835664153ebd1cfc36a1acd912ab65a755"
    sha256 cellar: :any,                 arm64_big_sur:  "6a7802fe12c93ffa224682ff3254872d6a0a0880ef1d89def564662683701af1"
    sha256 cellar: :any,                 monterey:       "36fc51b59e34b5b68ae7ffa91a52b1c509244cb52f64d3d8ed01b92a6eb344a1"
    sha256 cellar: :any,                 big_sur:        "645f314620fdc5d1334224875e481426829fc31c55907823bb80573b93d6107a"
    sha256 cellar: :any,                 catalina:       "5d2f599db0fc10620dd2b026ede9bec67d7b4e1c9d7117ab916999839726af10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c734b921f81634542648447bc3d080bc367724236879a94088e3b1fec2da90d6"
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
