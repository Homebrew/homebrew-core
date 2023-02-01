class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.2.13",
      revision: "17d9c9bc222bd3d90040d14ad161a6219d332e7f"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55bf3cc56f5f4118839752bdf1c75f7f87c266c938e17b3267400735b936544a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ebcf3bd3ae8d92c7c1405c7d2d4eac568efb7cacea2df940bb46913449e670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09d535ea17f549a2ee42a5f37e68e4b0b8d359de2b38dda85d3d830b04d0dc3d"
    sha256 cellar: :any_skip_relocation, ventura:        "3d2e60ab89c60bcb67e140b5189f477f4289734c79da227289107ee1e6c2c097"
    sha256 cellar: :any_skip_relocation, monterey:       "f50f48dbded9d51cd9ec26b594d223d9babcb05e1e9d813e8117030669580f8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8642f3420575b2e52451e4bdd47ed21ebb85b8cb5295515410e0d107985787f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c7280d7806859da24b022353c7bfa89d56b102ccc5a2f5c88c3541c75bcbce"
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
