class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3628.tar.gz"
  sha256 "cd15cb51c7779a069e3a1b8a41771bc99a9e161279ef0b2888e82c6a1d866731"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f59d90bbfb72e25b012c11e763cc70639031004c56fa662efb8edc1e58af8256"
    sha256 cellar: :any,                 arm64_monterey: "5223b436fcd167e101709c8daaa72b7b8c8e533dc8d7198355a60957e541f103"
    sha256 cellar: :any,                 arm64_big_sur:  "900ca99b6b0f865a7f5f3cf0186b8e0fc0e3e4747d2744646b70b333360e5fd3"
    sha256 cellar: :any,                 ventura:        "35ec5846124a738782dfeb11ca03e4c67461c360fd1514c8be110dc9207a44e4"
    sha256 cellar: :any,                 monterey:       "9ac3858f1e422edb34ce5e2aebee07c11fb26942222cd75a25360cf00775d8db"
    sha256 cellar: :any,                 big_sur:        "847f538a20ef8c33e6ceacad59a5950effaa37ed33586d630c51ef8869715574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385bf4c82ff77f7bf9775b2eec3dc6dcc84db07b765fe998766d3c3a53c4de0d"
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
