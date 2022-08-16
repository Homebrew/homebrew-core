class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.8.4",
      revision: "feede84577362168b220f01676b9868c3fccb1ad"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "449c3ecc952e64abc089b71cf1f2107fdab1696c335090e802b34f264d25106c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "606e7c80dfa647a99a615bbc1b0421954c245d32686986a7c8c71697531f29c2"
    sha256 cellar: :any_skip_relocation, monterey:       "14278aaf726732b96d0125fb94daff1b0d96c87f8c80f997b59f1f81c22d7c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7d29da0fe3fa33688491b0adcb0d5de05d66189efbbf393b7d3fe16f82187aa"
    sha256 cellar: :any_skip_relocation, catalina:       "677de91556ec16856f19db9313e3d05a81a3f818e22a4f3dd0adebf44a8fc081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ae61cdfac6d8bbad689444b72186aacbe3b10308c97c4e987411d2871ac3c92"
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
