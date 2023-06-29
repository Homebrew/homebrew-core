class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.7.3",
      revision: "40a23e3c99bd5d3a881848b976ad1a086e5ff360"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87e4f9b30bd27835cb9a98edca640ad5077612e74b2f46d2feb809c1229f809b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ab9ffc40ca9a3686e9742d96fbf38d33a38df83ae171701b97751564602a51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7187b1aa4c6838e4cc2313c1a1d0dce852810475b7a45f45a2a98ea47adfbc7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6f71505766b2b0a0e0a763302671515196b508b0261a52a47cd89232af9bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "fbabf16f3b42ea2b52e80366fa92dd46f4fabf0a5d00833127b438b873f5c522"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f3ea67e78fe5bae4b064862a659e9fcc3cd02e46d5a01e22d9200ba6d4c547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02624328f51ddffd8553e4f3689d38843de2efb22f74e83ab01a556dd056350a"
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
      ASF config files should be placed under #{etc}/asf/.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
