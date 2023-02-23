class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3247.tar.gz"
  sha256 "d996a3229143e032947f8c9ff412c4b0ca52d15441ea0a1cdd444912ec235566"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c77763657ba0cf9d931f3d4758493e56321f9694f3e5cadf96ea563c2d4a076"
    sha256 cellar: :any,                 arm64_monterey: "af69efb2eb1ebf3ba99924aec2eb2440925658d00a9bcb106e76612975694e7a"
    sha256 cellar: :any,                 arm64_big_sur:  "7620f8ae9f01048a47f1418a1c98600faf0c7195ee397be9d72e98a6f06da425"
    sha256 cellar: :any,                 ventura:        "4015ef985fa9620e991892c8d9d5dfa37cf093cf632940ee07b27709fddb74b6"
    sha256 cellar: :any,                 monterey:       "d8ef607cd77764837a1760eb0982c9d27e17635234af9898556e8275f88bfd8e"
    sha256 cellar: :any,                 big_sur:        "7a9107b3013684615b41a4d02f2de9b320427bd349f6110daabf1909ca0996c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edcbf872473e7e2ce28f54cc85c086381f5cc5eaacc3eb4a378c3b2958e8af0"
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
