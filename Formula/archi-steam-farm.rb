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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "208281b71c8bed1a02ee22e211ae26864fbb67325977c3787d8441b5669955fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c83bb0a10d5f2dd5961a80ebad8bbf7a0fd6f0ae24e3932d683e0bd72ebb4e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "505368b47f9d693f78ba1dbd272b65b5dfca31903f642464520dc8401550476c"
    sha256 cellar: :any_skip_relocation, ventura:        "8f6045e3ec66b7246f44f35d6c368f47a40545541caf0104272e7d58e892b620"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a88fc3195f8cb5ea17983e0f9a64066d5de8711e725d070df7cf3089e42b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7181c0e91495af2f69e2101c63535c8421be3067fbef24668235a3382cf0cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a150fda1df849a7ce3d785248a5156fe43ffd9836be21e3f709aee55445f9e6"
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
