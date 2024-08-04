class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.409.tar.gz"
  sha256 "00c0f5d236337ac71f11f471007b464e96a49d8240d0cea588c77274023e3c4e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1024ff3ee38d71c0fcab6ddd738f6c629a13f5ac404b3a41da04c1376d334fa"
    sha256 cellar: :any,                 arm64_ventura:  "e046a07f8b4e4841551267e15abed65df957bbb2b8f9865ebcffbd0dd3024991"
    sha256 cellar: :any,                 arm64_monterey: "88ca5433088d134399b69415b70afdfd5e6326fb4253102638871ef0fb82a537"
    sha256 cellar: :any,                 sonoma:         "d93438133e9aa9d76ff168fb2df503f1bfe2525621bc79b86ee22fefe8a47705"
    sha256 cellar: :any,                 ventura:        "6fc47f90e523e74a7c10d4cb959e0c9ab61229bab9054d1b217bbd483aa93cc7"
    sha256 cellar: :any,                 monterey:       "98669230ebfd8bf4dec48e4991df6bc834bb4e2f28549bd11f033eb318c21399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9571cb39c3cbf85ca55e2a78798f24e27a408bde0ff07deb10339ed8de98d55d"
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
