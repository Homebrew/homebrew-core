class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.4.5",
      revision: "fc1bdb9b16e0f4ad4c2ecf7f37b4ee6be2b2b1b7"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2b45c414ab4636062553fe8dae187e04aff04e6fbfe547712c87399c948af3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431b7c09ae3148dca3cba4ff866205918dc03e6ac70dc09e2a23fe62a9695af3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbf5bde9209984ca2374806a578efb1db6ae2d058cf431a0406cac7429fd69f9"
    sha256 cellar: :any_skip_relocation, ventura:        "49b778bdc58960f59e104ff979777ebd275862f0afe4ac880b5083a4581f2754"
    sha256 cellar: :any_skip_relocation, monterey:       "c714d8b7ac4b1b49183af31ba17a734a551d1ab9666d49193fba064f2dd00f73"
    sha256 cellar: :any_skip_relocation, big_sur:        "a105898706180412770cef170f3006bd593f4d775b8118893e962648ba34b68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a3e182eaff224f42702346c2a87b9693b5e02c4e5080d2dff128c2e2382017"
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
