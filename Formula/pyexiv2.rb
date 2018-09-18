class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "https://launchpad.net/pyexiv2"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 5

  bottle do
    sha256 "c54c8221f94715c9226e26f5d050bec8619c66d5e553f090ab58b720b135887a" => :mojave
    sha256 "2dfb1f1cb5f11fe496f5b873a37d05fee2530da136d6f2df4152ba6263e6f9fd" => :high_sierra
    sha256 "01d50cbe2ddad34cb412b20de81c6594ff1a9ed5f139894fa14a120717c7b08b" => :sierra
    sha256 "53fb18abf4fc93c31ec50ed8d1c6ac51772176846ce7a07674058b9e78e59538" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "exiv2"

  def install
    # this build script ignores CPPFLAGS, but it honors CXXFLAGS
    ENV.append "CXXFLAGS", ENV.cppflags
    ENV.append "CXXFLAGS", "-I#{Formula["boost"].include}"
    ENV.append "CXXFLAGS", "-I#{Formula["exiv2"].include}"
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    scons "BOOSTLIB=boost_python27-mt"

    # let's install manually
    mv "build/libexiv2python.dylib", "build/libexiv2python.so"
    (lib+"python2.7/site-packages").install "build/libexiv2python.so", "src/pyexiv2"
    pkgshare.install "test/data/smiley1.jpg"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import pyexiv2
      metadata = pyexiv2.ImageMetadata("#{pkgshare}/smiley1.jpg")
      metadata.read()
      assert "Exif.Image.ImageDescription" in metadata.exif_keys
    EOS
    system "python", testpath/"test.py"
  end
end
