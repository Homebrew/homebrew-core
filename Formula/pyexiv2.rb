class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "http://tilloy.net/dev/pyexiv2/"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 3

  bottle do
    sha256 "92e4e745cc20cef9d1809f4cf86b0d84c8f3c1bd22ca1867d6fd85aeef8c9bdc" => :sierra
    sha256 "55378934bd6a10490e875b23b054a99ff135bc1508b7fd1311897b563f7a585f" => :el_capitan
    sha256 "4eb3c1973d2c4951b5ee0184665dfa13bbe5ed8b77b101ed5421c37bea1abaf8" => :yosemite
  end

  depends_on "scons" => :build
  depends_on "exiv2"
  depends_on "boost"
  depends_on "boost-python"

  def install
    # this build script ignores CPPFLAGS, but it honors CXXFLAGS
    ENV.append "CXXFLAGS", ENV.cppflags
    ENV.append "CXXFLAGS", "-I#{Formula["boost"].include}"
    ENV.append "CXXFLAGS", "-I#{Formula["exiv2"].include}"
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    scons "BOOSTLIB=boost_python-mt"

    # let's install manually
    mv "build/libexiv2python.dylib", "build/libexiv2python.so"
    (lib+"python2.7/site-packages").install "build/libexiv2python.so", "src/pyexiv2"
    pkgshare.install "test/data/smiley1.jpg"
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
      import pyexiv2
      metadata = pyexiv2.ImageMetadata("#{pkgshare}/smiley1.jpg")
      metadata.read()
      assert "Exif.Image.ImageDescription" in metadata.exif_keys
    EOS
    system "python", testpath/"test.py"
  end
end
