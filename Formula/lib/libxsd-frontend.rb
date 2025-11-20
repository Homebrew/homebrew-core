class LibxsdFrontend < Formula
  desc "Compiler frontend for the W3C XML Schema definition language"
  homepage "https://www.codesynthesis.com/projects/libxsd-frontend/"
  url "https://www.codesynthesis.com/download/xsd/4.2/libxsd-frontend-2.1.0.tar.gz"
  sha256 "98321b9c2307d7c4e1eba49da6a522ffa81bdf61f7e3605e469aa85bfcab90b1"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0932306261002d469d9a0a9a5071134841b5820b9e2880883e3f9c06f5b4e82"
    sha256 cellar: :any,                 arm64_sequoia: "3631cb5e92f7b2d727f1fe7039482a1a5cd1d81e317674fa418795e4691d60fe"
    sha256 cellar: :any,                 arm64_sonoma:  "cc7523a561914a469ed374865f6135e9756d7c08b8d3fd16a79d405523c5e338"
    sha256 cellar: :any,                 arm64_ventura: "2c8b2a9f341d970929e266b1c63ec298ec46029c7164ce41d554f24cb9ab84f4"
    sha256 cellar: :any,                 sonoma:        "b1d8a828aa8fd14ba6c3c361fcbdea0422df3a9182b9f380f0cfa71b6f4d1cb5"
    sha256 cellar: :any,                 ventura:       "820f8de1fffddd9f19537ffbdca74723121d8e751908a89bfd09fa6cce193328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d85d419e1276e6b49a4b3859d06b20ca2fec7baeeada125e94c20350031b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19114c72e4f6ecdd2628dd3f0a06c93b5554367b710f69ee8bf8fc060b1faba3"
  end

  depends_on "build2" => :build
  depends_on "libcutl"
  depends_on "xerces-c"

  def install
    system "b", "configure", "config.cc.loptions=-L#{HOMEBREW_PREFIX}/lib", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    pkgshare.install "tests/schema/driver.cxx" => "test.cxx"
  end

  test do
    (testpath/"test.xsd").write <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
        <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    XSD

    system ENV.cxx, "-std=c++11", pkgshare/"test.cxx", "-o", "test",
                    "-L#{lib}", "-lxsd-frontend", "-L#{Formula["libcutl"].opt_lib}", "-lcutl"
    assert_equal <<~TEXT, shell_output("./test test.xsd")
      primary
      {
        namespace https://brew.sh/XSDTest
        {
          element MeaningOfLife http://www.w3.org/2001/XMLSchema#positiveInteger
        }
      }
    TEXT
  end
end
