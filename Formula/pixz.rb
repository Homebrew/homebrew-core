class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.6/pixz-1.0.6.tar.gz"
  sha256 "c54a406dddc6c2226779aeb4b5d5b5649c1d3787b39794fbae218f7535a1af63"
  revision 1
  head "https://github.com/vasi/pixz.git"

  bottle do
    cellar :any
    sha256 "f8b5da517c4ea08d9dd191c90528fbeeafe696df565dcf7a974c61b3d635b8c5" => :catalina
    sha256 "1fba8335b8dd4b061f961ce2e5d03eafa550a7a92edc8b8a95b6129c55bd6b7b" => :mojave
    sha256 "4c971701c82c6444dec792341b49b8ce38e88b2d9e3d549c12433d2fef37cd0a" => :high_sierra
    sha256 "9d2f908cb1c21882c95f3c3284c9b4c1eea74c2b25d3ba6df9ad47fadbcc0813" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "a2x", "--doctype", "manpage", "--format", "manpage", "src/pixz.1.asciidoc"
    man1.install "src/pixz.1"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    testfile.write "foo"
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
