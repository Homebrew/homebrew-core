class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.2459.tar.gz"
  sha256 "3230b03941653ab1a194e00f786fb43b48740f3f924ac8ffd2345680d209ce9c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d50c44ae4480c8aabe977ee63a3bcad20895b5a1b659f877fe05e344c429d72"
    sha256 cellar: :any,                 arm64_monterey: "03eb89cd46a5d4ff372779a6ac5ae3270c0e681c0067844c0bac016969e09520"
    sha256 cellar: :any,                 arm64_big_sur:  "7da034d74a521fcc15d19303aeeacefe3815e94829d19a4909be0b8602707051"
    sha256 cellar: :any,                 ventura:        "928cf238ddccdf51a21b6aff74fa78ddbbc7cbca61e856566a6fb729c217135a"
    sha256 cellar: :any,                 monterey:       "88baced7ced568bfba6daf6b516a8da8211b9c2faa670ff36fac6b0e10681196"
    sha256 cellar: :any,                 big_sur:        "0bfa53329cedf1652c9bfb41e1e4382328aaee601921cbfbfd02028b35afed2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7379342d241fda2ead24a481657c0a057fcad6a20e5fcaed97c043ca6281314"
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
