class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.2.6.3",
      revision: "03c2ba049e814df1050c859aae0edd104e95022c"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95fe0d3d9cf6226b3228510e5c9fc616e3d99dc20604aebc7773db490655f1b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a82c78d7c6cb25865f712591424b4ea7d326c9f687fab999113deb113da3cb86"
    sha256 cellar: :any_skip_relocation, monterey:       "4c9a8fe652d11efab6faade16239c151884b5cd453cbb37c4c03e37fb2e29290"
    sha256 cellar: :any_skip_relocation, big_sur:        "87c1f1d9c448b902d5583f071afdf4dbecd87385b7d9b9b5516ef0be058c1c93"
    sha256 cellar: :any_skip_relocation, catalina:       "6c5078098421a2bc093283f5e4940af6b6ac522130b18c2fe2d307f1fc5539c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ca58ff37df25c1af9024578c59c38bc0a99ab23aa608daecea409b51268567"
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
