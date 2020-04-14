class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.9.tar.gz"
  version "3.90"
  sha256 "dbec812eeb307b20caa88af80eb843fe7c8adde4d3a25159dad77a9f0afe040a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed9f4ee60ea875c0e06b873dc3f5a13a7b5f981966a10425418da459fbe3c0d3" => :catalina
    sha256 "b58a621bacbdeaf1e126368f30dcd7231fb4dc1b8313d922786b7fb535cafb3d" => :mojave
    sha256 "efc3dea6a94cc6976ba95d1931ade0768a5a8f6ab277a369601954c44f54b213" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "isn't available to LFT", shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1")
  end
end
