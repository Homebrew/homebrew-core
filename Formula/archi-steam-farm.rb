class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.6.3",
      revision: "0c85c1413d9367be23e10ecc95c5dace9542308b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88f0c209c7cb409c51111348cd96b712559d438585124b59a9d191afbfccd36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc231cb415b2857044980605328e207caf90442f924e12feb6358bbf2d391b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df2e50605fe34bf6cd7c86a7265686239d7dce51ec4b9ff5f40841947a0c51fc"
    sha256 cellar: :any_skip_relocation, ventura:        "8b66e4fa4c9482dacb098ad8b5c5a215541a36466e2fa3f587a4fa9043027748"
    sha256 cellar: :any_skip_relocation, monterey:       "3c102306c92210f387383e29ff1f4e6d206d0e05626e9e4f790677ff1b1e8c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0ae9e03e971a46105e2af3739dba0543ab3237e3373dfa6be370a4e29b6d3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550882d9b64326b54ee5ed1b6cd19eaf66a7948d6906f7e4f3dcf65c81aa68d6"
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
