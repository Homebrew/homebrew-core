class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.2503.tar.gz"
  sha256 "9523b192d900300cd18b806f90085124c9ecabae819c00a6a4b0fc3c00a0ea49"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e726637607bee444100e3e0d6ebf1c466da9049c4f1dadf9a0e69ccddb849084"
    sha256 cellar: :any,                 arm64_monterey: "264c57646f384922eaa7dae83db33d2a894dc76114882d808593f99fe999ec13"
    sha256 cellar: :any,                 ventura:        "4e6cdee3e2455377cd95f66bfc99f220963aabd1c851bf42721ab8b7cdf55044"
    sha256 cellar: :any,                 monterey:       "27a4f539c29d04ac76070e73bdac6f01dcf8a0241da65b147d3f9a4fd67f5c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a1d455470a2c04326b9a3cff9f28ba0a232133fb1d2321449c8b12d3c0fb7c"
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
    working_dir opt_libexec
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
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
