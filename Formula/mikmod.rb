class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.8/mikmod-3.2.8.tar.gz"
  sha256 "dbb01bc36797ce25ffcab2b3bf625537b85b42534344e1808236ca612fbaa4cc"

  bottle do
    sha256 "6d6794da1daf749a56cf55738f796fe5b6a7b337456730b21a5efba2fab60f38" => :catalina
    sha256 "6812f223d67d763208eaf21ab6e1ebfaf50e349852cb6820010010ed0524b2f2" => :mojave
    sha256 "5907f92b40ddc0ba15cddd60269a9f9a8e9fcf6295a099df4145818536431427" => :high_sierra
    sha256 "a9586a9306006e8fd451aecb6c3259fc57cb0bb328a2b0ce8c064e5518f943bc" => :sierra
    sha256 "ae0b4480b6b34327b9c99601d7e2cbc9648ece54344bd4bda3582ef048e1f1de" => :el_capitan
    sha256 "7d52131b792e01d3037dac4be52811744dfad23c2a11f4ee3d1985a8fb8f0331" => :yosemite
  end

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
