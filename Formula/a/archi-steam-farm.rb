class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.5.0.11",
      revision: "3c2a154b3911885e813471f61def2b5f60e5971a"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9ed64c22a0f38c76bb217e25721b349070fc04d3b2bd84d8df8a460870bdb9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d0ed4c90149aabc9a70b5c23588c13259149276e653deb07e21a3a0897d3f67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "960ca079b5e1265c66c26adc6d18e9d2508376556a2b3a3d86ff7672a2885aa9"
    sha256 cellar: :any_skip_relocation, ventura:        "6051073a074ddc221222db50a0544f0ba9904688f51c3dae525ce64ff1ad105c"
    sha256 cellar: :any_skip_relocation, monterey:       "b5255a59dd07630a94b6796786b4dfb3595d2e8caaf8a49ed5f971f9ff97accc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2042e4f16da582d2576cbf7251f2ec6d0a13f8025f48cac015b27084b06a325"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `dotnet`"

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
