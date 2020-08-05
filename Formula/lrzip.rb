class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "http://lrzip.kolivas.org"
  url "http://ck.kolivas.org/apps/lrzip/lrzip-0.631.tar.bz2"
  sha256 "0d11e268d0d72310d6d73a8ce6bb3d85e26de3f34d8a713055f3f25a77226455"

  bottle do
    cellar :any
    sha256 "15f270984b1591a12a87dc8698edb9be86df691f8081f204307a6176325a2b96" => :catalina
    sha256 "c4fd1cfc9b09ab7f175bd056865c8712f9e6310c918cd03cfdf6e30f283c8761" => :mojave
    sha256 "97797937ad456c0658fe24399dc757f30771e971647395fe1fefaa227f615fea" => :high_sierra
    sha256 "b0c60e0773da9cf70d3164f362b3b527a7a87acd10b632291055d58ca2da7cfc" => :sierra
    sha256 "c0ea3854495bd5d98f040f1a6b5a08e01857436aac25ead3f7a3fb44841f738a" => :el_capitan
    sha256 "345d0f65ddc44faab696c5e5bfabf6a6d408435858f49cfd630ee74e61f0c97c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lzo"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
