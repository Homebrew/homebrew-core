class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.9.3",
      revision: "a768ec43a54ef886180925a1c4ca189026ffd348"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a74bc76cb3761251d73648a182f59b86c361daf135501ac1d5144490110a274"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8290bb8a9472b631db57da1b013b125e735c73abe14c5817809c88511f8cddc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392ab67e86968d9cde612345d9192bf80f107864201437e4a63598d697f85269"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc41dc49607ff8a8c9bfbc7515ee69db62625d9ce3345fc05c464ba642b6453"
    sha256 cellar: :any_skip_relocation, monterey:       "e0df1346cda4e9de07851f945c9504e95dc766a4de2f5873b56a3d1b9ae18710"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc4d99857710fdaed07cdbe6d6765ce25a017ebd17805c5fd383ee8bcc6c78e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc5f7a9d28fc87375331d022b318734722ca9198597aa4f8f71bf2fc8f5e460"
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
