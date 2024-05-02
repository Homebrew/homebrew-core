class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.0.2.6",
      revision: "efb726211381a781da086415a6414ae3038d98bd"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22df7be8eddb4585f6ea16503f9b2c7815b43641745d020cb14927f813b70027"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f947392331652d81cd1c3f0b89a5e91023e0f56d4847e3e8a593f13db8e2d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c41f591d6cd56a7c88f82eaec6bdb35736f67c9d00628a63ec55c428e68941ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c3328e46124bf30ac7898cccbac78fba71bc7fdb7266b7ca786474a348fb28f"
    sha256 cellar: :any_skip_relocation, ventura:        "53989b561ea69f58ad7b2770597cbc66391244ef5c52adcd9b26cf8833aa408c"
    sha256 cellar: :any_skip_relocation, monterey:       "810551a481a100f89ad52014f9cfca01838a86f4eaf8ac1fe30f7dfbe063db8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d5672d8eb1c05389ecd81d22d8a6c7f5bf9d2c8774158c575e4698f2b2d3e5a"
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
