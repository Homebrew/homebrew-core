class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.7.6.tar.gz"
  sha256 "36298549deab66b4b9bb274ecbe74514bb7c83f309265f8f649cf49a44b9bd9f"

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
