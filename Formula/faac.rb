class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.7.tar.gz"
  sha256 "b898fcf55e7b52f964ee62d077f56fe9b3b35650e228f006fbef4ce903b4d731"

  bottle do
    cellar :any
    sha256 "32bd90ecd29994d4897c24db4d8b3de36d0a9c13c749b56a964b930b8a59c189" => :high_sierra
    sha256 "847dd177583c3a5d7339a0faf00aeae9c7894a343f8cc0ac6cd473c8509de94e" => :sierra
    sha256 "de6b1c4d89b263193f0232752090ee0c53e2438116122e04f68a780c11bc8d91" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert File.exist?("test.m4a")
  end
end
