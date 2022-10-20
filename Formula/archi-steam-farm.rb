class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.3.1.2",
      revision: "ee4d5561dd90064189140611d7a1065d653a00b4"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d0b5cd305a10e755f3a722f0e8ae39dfcc9ff6e4356908a4a2f680948c02360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49e04e344ea151bfb7257fc25af4ad3924593dbdc7751e92dc4e79cadb12c943"
    sha256 cellar: :any_skip_relocation, monterey:       "a33c65e5afeede009c3d2de6e07684ab8d979caa0bcb2fc8d85f0ac39dc98cbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a48942cc7e41b5be605f86de4409f4eacac913be3ec2f5510cd9cef9bc0babb"
    sha256 cellar: :any_skip_relocation, catalina:       "5eef84d5aa4ca35ce132e41a9f4471e9381866212a2ab3c92cc237cbcf39ff40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2b74e373e2c4d6a064f7d936dcad6a438e4cdc636e99ab04aa24695d45a91b"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish", "ArchiSteamFarm",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec

    (bin/"asf").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/ArchiSteamFarm.dll" "$@"
    EOS

    etc.install libexec/"config" => "asf"
    rm_rf libexec/"config"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      Config: #{etc}/asf/
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
