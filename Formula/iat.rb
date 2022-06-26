class Iat < Formula
  desc "Converts many CD-ROM image formats to ISO9660"
  homepage "https://sourceforge.net/projects/iat.berlios/"
  url "https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2"
  sha256 "fb72c42f4be18107ec1bff8448bd6fac2a3926a574d4950a4d5120f0012d62ca"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093c585bccdf3c2befc96c8050fc922267769a8d11e5d8d613aaaf5771ccc5cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d62b3a234d80f15acfed8e030897b09f88678213024c5b5f47ae667507984d24"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd2da0793bd90422e81e10cc2748b3d5c27cdb8fb2e47d167cc0bf2a94ed096"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1a5029ab927dc08cf6cf89a583c52e475dd50521d461f5ed3d05056a7605dc1"
    sha256 cellar: :any_skip_relocation, catalina:       "6400e0c863f951cf324e9630ad9de91cc099e5d3f9cfd34f3cfa4344eb747cf3"
    sha256 cellar: :any_skip_relocation, mojave:         "e10169c9c7101efb0cfa7670cadbed74dde199b1a8d034f73e906f897be1bbc2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "799764ef75d9efdf93f92a2fbc2beaedecd6037eae45eaaf7ce888c2ef2b3eb3"
    sha256 cellar: :any_skip_relocation, sierra:         "97d378d0b0ee8bb685272d126a54c833ad8d9f7f3ab34631198d054d2f1d0bdf"
    sha256 cellar: :any_skip_relocation, el_capitan:     "baadc7c40697b28b46c7541d617f65ee318b78efbdc4156c6527490616fd2dee"
    sha256 cellar: :any_skip_relocation, yosemite:       "db517ebd84afdeabaf2e130faccb88f33f359d13eab3bfbb5e19013051ca7827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6c91342941bb21b0ac060ac56c8453578655e499ef758ab2c7366ce2052d47"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system "make", "install"
  end

  test do
    system "#{bin}/iat", "--version"
  end
end
