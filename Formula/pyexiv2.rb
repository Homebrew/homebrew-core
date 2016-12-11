class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "http://tilloy.net/dev/pyexiv2/"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 1

  bottle do
    cellar :any
    sha256 "bde650f330a8e897f2a47fd20d27b2903a1530dd7fb3bf52e8118d74a596c00e" => :sierra
    sha256 "2ed37d8bcc496b353b99a139209a2665c0e414505eb0ee4c5e36d2acbcb54aa9" => :el_capitan
    sha256 "26b9f2b36d116de1d5b3e6813dd279436e31324e79fbb605f02779ebc2095fe9" => :yosemite
    sha256 "fe553c6754fe6676f677e32e9a60b65a36e36d52ac9149a68d511556a4179a98" => :mavericks
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
