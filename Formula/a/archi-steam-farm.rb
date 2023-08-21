class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.8.3",
      revision: "35364e46caeeb9f10e192c09c888d71d6252351c"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c45ab93cfc35801116d09ec47ab1d8d5d4b86ed9516fef4b154a23460bcdd0df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51e816c4c00086a47ab65335de0031c5a635934853b7c6bcc560a91a7a48db7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49bc200fdf4e13e2de99c2b91336aa4185de6513139a118ce9033ce1f6e4fc94"
    sha256 cellar: :any_skip_relocation, ventura:        "ebdb96dc462ee62760698762b9ff63e2f977f25897dd19732acc86f2d08f857a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e6c75dc8139e1377ffaa728fe8defa09f00aca4e8c877d4a4bc9d39ceb76e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b62f5a5fe1dbec9961a254069ddadc0bfbe31672b34f844594de65b424f7f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed244833513dee4c147572b84b22e1c1313b4d6de4e8b051545658a256b5f305"
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
