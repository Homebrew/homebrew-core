class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2280.tar.gz"
  sha256 "bb9ada32b381a3687394a643a84ec44566f93b00266880780becc2a7f3119175"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "844d7190ff17dfd1f2f2c37ed6f68f9cd79f2f2f2a38eec48f53d29e28ac4c67"
    sha256 cellar: :any,                 arm64_monterey: "34ee70921ee6fe5badca82425a169f1649b34eb0b73e94458b376a0ffca07d14"
    sha256 cellar: :any,                 arm64_big_sur:  "0f88b7a77a577698d882131d75b45a4c94e00a8273a71b7358bbd97ed768c97e"
    sha256 cellar: :any,                 monterey:       "959755ad74d4b457208f206d2e85391e941d427f793d9f9e4d7542eca6e402a9"
    sha256 cellar: :any,                 big_sur:        "0694304d55ca615386b5b63810d00b13708615d9a06917e81b479e5a01202111"
    sha256 cellar: :any,                 catalina:       "20a7f93f78778f7374081626cb119a1890331ae06a9cee224a7e8bf9a1027468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02219ae5dfe7c5fbb11530e1a272837bf418ae2ae6f52f995069ee6ad6d23899"
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
