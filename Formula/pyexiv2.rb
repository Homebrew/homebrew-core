class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "http://tilloy.net/dev/pyexiv2/"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 3

  bottle do
    sha256 "44a97c27ad937f771fe3ef93bda6d88ecfab78a9b579ee9f6d48e55c051716cf" => :sierra
    sha256 "a31fab0ae66512370a1955e1f347e9594ff5be04b9636c1ea5c54f68746b936e" => :el_capitan
    sha256 "89ba145ba9594b4492438f220115847a8fad9d9cb68ed52b0f7ebe45f053d8f1" => :yosemite
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
