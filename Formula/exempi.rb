class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.6.3.tar.bz2"
  sha256 "b0749db18a9e78cf771737954a838cdcdb1d5415888bac1ba9caf8cba77c656c"
  license "BSD-3-Clause"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97651c0a4eb2423fcded41f3209d949c03fd716a6a0d42bfb159b60f7545da60"
    sha256 cellar: :any,                 arm64_monterey: "81083b7540ea99869871d809f8695acc3dcdaf7f42b721df9e6aa5533a7be27a"
    sha256 cellar: :any,                 arm64_big_sur:  "ce707b14326edfbb5253733a2037cc64710ed23d00dfd4a6c9fb202173c46855"
    sha256 cellar: :any,                 ventura:        "389ab1690ff9bd6686ab24f8366665ceb75532aeb58de0abcc680b4815b128de"
    sha256 cellar: :any,                 monterey:       "e6cdd5b60032ce94ecf1ae11877274cf846a446bdb5d23a772683bd642165786"
    sha256 cellar: :any,                 big_sur:        "a73e171a6e04877fb8ff2cb0de150b6413fed73eb77fb6bc3dd358bb2a6b7938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a1afa2bdce46b3f665eacb8d4a91e3dcf92e9aed8e74a7a46f8c038acb4539d"
  end

  depends_on "boost"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
