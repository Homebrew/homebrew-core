class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.735.tar.gz"
  sha256 "be997bafd58ed53a9edaecd27f22df9b4403e798a0ac94758003e82e262860ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "092ec0799a66e8760f2b3f2376097d4d5d2e43c539313a0c24ecc4266beef419"
    sha256 cellar: :any,                 arm64_sonoma:  "284b2aa3f026735daa86de61091ebbaf168b7dc7be0abbf67fee358a2f2d8d2e"
    sha256 cellar: :any,                 arm64_ventura: "951bf9b6927be31ee2feb9882995f1c2ec19cee560db0450e6f756d1893e7349"
    sha256 cellar: :any,                 sonoma:        "0d590d6c9bf57bb63f931853dabea657ac87ead8a62701dea0a557822b3cc331"
    sha256 cellar: :any,                 ventura:       "b2127ba265212740f4f388ced23b36c250d9ab82218ed8b0efd6d096a43b2d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869761849d672870cd44c5bc0bf0fa5317fc7221d274c6c714cfe8e357769852"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
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
