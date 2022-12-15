class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.0.3",
      revision: "113e0c9b3c5758ebb04fa1c4a3cac5fd006730fc"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d753ac8aa090d33f08b44415773b313587a855ba7e311a21dcef852533fafa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a3f918e5ade9b72897435a6473a31166ca341af0b930c666dec42d345a7a9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976988e1a6a46be753bc392b90820a8230d05a3f3537ca09a9c32b5123b97284"
    sha256 cellar: :any_skip_relocation, ventura:        "24d0cd729c9b1323c6fa011d02ef80f289d803c283fa9cde9b8e0d18f41b82be"
    sha256 cellar: :any_skip_relocation, monterey:       "a31b819a8478784b1560a8510ce8c24bf973b87d8fae13cfec508cde7636cbb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaa0c1cd1b7ee9aa5919e956b3d32b0e6edddb9786287bf6c703fa4086ab18b0"
    sha256 cellar: :any_skip_relocation, catalina:       "47a4d4619c94f2ff2083e3b12cb957c25ba3fed74200d34bbfee2855dbafb700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac082fa8b2e5290f6ca0ba0559cb078b08a1b45879d47b7a4a4e9bea03a7cdc"
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
