class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3160.tar.gz"
  sha256 "032ff1af958bf1d9ef0daefa92429c7bf382f6e9d4f66c9def753879320ae255"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c77b3a5e52609a3ff2686cab2634fbb53a4af6c707421f2747f4258978427c3f"
    sha256 cellar: :any,                 arm64_monterey: "9a789574b74faef371e5d08fad3889e0ab07762a9e599de6fe527cebc28fcb14"
    sha256 cellar: :any,                 arm64_big_sur:  "8334fccc9408578ec08d61e14c5e682d408b83646e9f0f5cd73fee3aae9c1b02"
    sha256 cellar: :any,                 ventura:        "858edcfe8537e07fb3f9afb1a2691a3d9aff7eb6569bcdfa7afbf57dc94722bf"
    sha256 cellar: :any,                 monterey:       "6fd90f73a047bb569c74601eac415c57d552ab6e524f9ac4496173b4f99e42cc"
    sha256 cellar: :any,                 big_sur:        "8b7ea9c587ff4a1289e405396c580a3f4e42191085d9546afad8e2da180c9cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eef28cb7f7788570c6a72c2bc268cce1339ec444cea5790dbfbafa7eaeae43c"
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
