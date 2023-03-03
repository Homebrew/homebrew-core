class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.3.2",
      revision: "10007e0752b60474ac71017e36677d2f5e998914"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97025b2569fda36e5e9fc9d08550ec64fe6ec9daa5a49c53981d11a4d6dfd7ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34f5a61d4811c227c03dad07ca995d9898eb497c6c781a53417d72ae257169be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae90ada45511d24dd87d2a0c672127c4865d5f085f3b9dfc7eb1aeb06adb8c3"
    sha256 cellar: :any_skip_relocation, ventura:        "d71306066322414c70cefe453168e7c048dbeed08a8e08869ac492ae8f9a4afd"
    sha256 cellar: :any_skip_relocation, monterey:       "021fee9793fedbb24f61c2daff340c149cdc5db8e0b3d91993724507f86ac6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba40cb8c43051293cf3bc290461073c086b83c114a9f9934149faa5871269af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7c7da79d7dc2a809f7f15055ebaf882acce5ec555a3a253b74993efd3534d6"
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
