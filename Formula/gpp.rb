class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "https://logological.org/gpp"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.27.tar.bz2"
  sha256 "49eb99d22af991e7f4efe2b21baa1196e9ab98c05b4b7ed56524a612c47b8fd3"
  license "GPL-3.0"

  livecheck do
    url "https://github.com/logological/gpp.git"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f6dcf32a23b4dfab4c9fa231757f87a9eb8f4ea2fcd4e8146a02e8afe22b38cc" => :catalina
    sha256 "54f5f9b098335023273291b6ec95615148ab3fa02039a0d7c1645cd59d0eb134" => :mojave
    sha256 "d56879d518d9924d17327594b31501c8ea4eaa58295e12ae41fc74156cffc179" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gpp", "--version"
  end
end
