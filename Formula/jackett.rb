class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2086.tar.gz"
  sha256 "292aaf1619941995ce7ad4cc1492189ce5b57bb4fce9fe01b66e6831157af723"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "09cd4e9470ee2cc5f3e21af1bf8d290a823452866d0e0cdfe47bb62b8c2ede24"
    sha256 cellar: :any,                 arm64_big_sur:  "11265b19eae2710f9b5cfbda32bf524054cb0ca3f24c079d5a7a5c5ff38d9fe4"
    sha256 cellar: :any,                 monterey:       "93b856bd8855170ae984fe15578e94d8e3fd447f780c57152c69a0cafa745f45"
    sha256 cellar: :any,                 big_sur:        "eadb5f673d7d669320bb34af61647ebde0b28a68ec09fd296a08631797c467c2"
    sha256 cellar: :any,                 catalina:       "2ad3c8bf9d5217ee7a0b8869ffa51c5d21d7dacfec1c066e5b8c5d5db1d75afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d24e760fb4dbdf1ac352d520725170b6962687ff92bda15f43be2a464fcb77d"
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
