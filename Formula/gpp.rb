class Gpp < Formula
  desc "General-purpose preprocessor with customizable syntax"
  homepage "https://logological.org/gpp"
  url "https://files.nothingisreal.com/software/gpp/gpp-2.25.tar.bz2"
  sha256 "16ba9329208f587f96172f951ad3d24a81afea6a5b7836fe87955726eacdd19f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1321760033d09fb720739a4f261b55873ff68f76241074bd2608c4d9b07cb3c1" => :mojave
    sha256 "41c9826ea93e97915c36193f637c3835e165fa90aee154d29b708895bbdd73af" => :high_sierra
    sha256 "ceec5eeca75c3ad3e2192f9fcef09857533de93e92413cc501e23e9b494da0f7" => :sierra
    sha256 "2a7f2e1371f6bcbff03db5b9b260c47cd41cb25ec1e5726dfb5ef838f3c417e0" => :el_capitan
    sha256 "2ea663aa6b1be3c2f6f11b99a31663aeab30c9e7de3712886b23b4c7cc114a5b" => :yosemite
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
