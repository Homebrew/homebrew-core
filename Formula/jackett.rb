class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.584.tar.gz"
  sha256 "c8be841886cbdfd83498ecc155ff584cbed79d74adfb759a4c073a4d8ef3f00d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c86ba00e812bc343e1e56004303f3c4139245a5cf7633120593f4f93dd8e8ce3"
    sha256 cellar: :any,                 arm64_monterey: "18b584d87e00689ed129f120a15eac0eb3716747517dbb572ebcbe1f1ee4af8c"
    sha256 cellar: :any,                 arm64_big_sur:  "c32e43c47a4ab28507138696bca3f0a7a7ff9dff702e7ce0563967a9354e3986"
    sha256 cellar: :any,                 ventura:        "4e4014d2277b40c807ef09ab3ebcaa61ac5afbb5c27d5e9965e796111d02e10b"
    sha256 cellar: :any,                 monterey:       "2f121ee7bf5f16e0fceec86161e245f366d736faa70f1dcb58c62899d080ed55"
    sha256 cellar: :any,                 big_sur:        "e527e15765e306c4fc62d45e5f44606c52cd2ca7abd48a6027e6a0cfb93364ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10b97bcbfa6551f7adfe55ff97450c47220f9cc0ae99e9929cf05f19e8bc472"
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
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
