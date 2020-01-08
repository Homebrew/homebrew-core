class Cmuclmtk < Formula
  desc "Language model tools (from CMU Sphinx)"
  homepage "https://cmusphinx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cmusphinx/cmuclmtk/0.7/cmuclmtk-0.7.tar.gz"
  sha256 "d23e47f00224667c059d69ac942f15dc3d4c3dd40e827318a6213699b7fa2915"

  bottle do
    cellar :any
    sha256 "fb552e12a3c59e2ca6a9dd89e9ec229e5b815edef28093c3902fc4ee54b52207" => :catalina
    sha256 "5c71a1746a8ca516dc5d11858a7d0d85341cafeea31797b926eba3a9ed83d9ea" => :mojave
    sha256 "85a6d2a8fcad4e2b6e7d9d22ec74dd5e5f463dabc5b2f01373d3a48178b2ce6e" => :high_sierra
    sha256 "716c78af6b276392a20fb02d58ff60e705509117da932d62d3ff8c6e4dd0bf5d" => :sierra
    sha256 "c647327d709c3b4a93d5541f8b340d2726540c9efdcbc53d1124043c8c4989bd" => :el_capitan
    sha256 "320a3590af1e9a1bee6827eb71e4d91fb283952f178b7f0393406a120046d4ee" => :yosemite
    sha256 "37703a65f22b994f724e54ebcf19ab8204b6d7a27e17d176af13440f611642a3" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
