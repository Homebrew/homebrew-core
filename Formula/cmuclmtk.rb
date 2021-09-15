class Cmuclmtk < Formula
  desc "Language model tools (from CMU Sphinx)"
  homepage "https://cmusphinx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cmusphinx/cmuclmtk/0.7/cmuclmtk-0.7.tar.gz"
  sha256 "d23e47f00224667c059d69ac942f15dc3d4c3dd40e827318a6213699b7fa2915"

  # We check the "cmuclmtk" directory page since versions aren't present in the
  # RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/cmusphinx/files/cmuclmtk/"
    strategy :page_match
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d3069c3fbd0f41bdb0b3435b7b388f9e6051639421658663185bde9a449185b8"
    sha256 cellar: :any,                 big_sur:       "e126c9d5de2e1f4e23d4fea7e8ac51c6fc2d4328a968c907879f4ea86524fbbc"
    sha256 cellar: :any,                 catalina:      "fb552e12a3c59e2ca6a9dd89e9ec229e5b815edef28093c3902fc4ee54b52207"
    sha256 cellar: :any,                 mojave:        "5c71a1746a8ca516dc5d11858a7d0d85341cafeea31797b926eba3a9ed83d9ea"
    sha256 cellar: :any,                 high_sierra:   "85a6d2a8fcad4e2b6e7d9d22ec74dd5e5f463dabc5b2f01373d3a48178b2ce6e"
    sha256 cellar: :any,                 sierra:        "716c78af6b276392a20fb02d58ff60e705509117da932d62d3ff8c6e4dd0bf5d"
    sha256 cellar: :any,                 el_capitan:    "c647327d709c3b4a93d5541f8b340d2726540c9efdcbc53d1124043c8c4989bd"
    sha256 cellar: :any,                 yosemite:      "320a3590af1e9a1bee6827eb71e4d91fb283952f178b7f0393406a120046d4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708324bb6cf751c76f927c6a648416ee38012499dddfc80c4b2c50cf36431c4d"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
