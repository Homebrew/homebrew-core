class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "https://logological.org/gpp"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.26.tar.bz2"
  sha256 "4176aa5e37be1c72cb8a90a371ecb2d3388c772814a34debe0ff581f2e1dccb3"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b18d4755835ab3cad89e5d90b459475dd499695d461a6c8ac4df35f07a11b1b" => :catalina
    sha256 "d83bbb08210bd763f300a44c9cae8cf8bad7070fcd0e8064e2c81f6c385937b8" => :mojave
    sha256 "c45c620602411620fa60c1b780a0a9b6172606f9f03c9e7d18e31e9c1276b172" => :high_sierra
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
