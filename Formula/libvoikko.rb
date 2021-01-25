class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.tar.gz"
  sha256 "e843df002fcea2a90609d87e4d6c28f8a0e23332d3b42979ab1793e18f839307"
  revision 3

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0d36dae546a309c83750f42e8eba3b6d9b51765f78093a9b6bffa5c9d5bc0cd8" => :big_sur
    sha256 "32d024915b3a784c2142507c1d8c0b2ef675635ef9e387880b467a2c8aa7044b" => :arm64_big_sur
    sha256 "94d12634dd73cba44a8e8c0fad1f2a2bea4db5ef50bffb277faaa400f798ccb0" => :catalina
    sha256 "bc325b6ce79a331c7046c54449174ca7cd2640703e90f50244b5ddfe5ed8de3b" => :mojave
    sha256 "5171bd4eeaba0f6712fd945622f76c0d615f3e6fad826329fa2ce77d8711380b" => :high_sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.3.tar.gz"
    sha256 "37b7886a23cfbde472715ba1266e1a81e2a87c3f5ccce8ae23bd7b38bacdcec2"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
