class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2122.tar.gz"
  sha256 "2124628f0ef7a83e85184d7cb3d82d3744e8c86dab269e268922ec24337e535a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "053b9445d8277b6112f7673a8742d5bbdd4bc76a82476df844f48846f6852f32"
    sha256 cellar: :any,                 arm64_big_sur:  "39e74e217acb479377a26c536d903e0cfb624935d8e906a84ce653729c82d2b7"
    sha256 cellar: :any,                 monterey:       "5a5463782f983c1ac8b20b53bd23aa4e1da5bb1cf6f7c84b155854c9c9e4fd65"
    sha256 cellar: :any,                 big_sur:        "810fb0ae9d76997c2e00489737285bd2d3209a694e76857b08dddf19d9d6b1b5"
    sha256 cellar: :any,                 catalina:       "58f8a14850a928dd468c8ae5d96a70edf688c791ad19a63975cafc4bcdd401f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2309f7a60fa60b0c541a1f873e9ff38379f4ba154d6dfe1fe5bd156504e13474"
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
