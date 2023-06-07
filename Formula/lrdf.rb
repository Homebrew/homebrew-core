class Lrdf < Formula
  desc "RDF library for accessing plugin metadata in the LADSPA plugin system"
  homepage "https://github.com/swh/LRDF"
  url "https://github.com/swh/LRDF/archive/v0.6.1.tar.gz"
  sha256 "d579417c477ac3635844cd1b94f273ee2529a8c3b6b21f9b09d15f462b89b1ef"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a0af2e4b47ceacad5f819b793adc705ffa969031d21959cfa415f5d94ab6899"
    sha256 cellar: :any,                 arm64_monterey: "a335b0fe4f73626b825bae7a510a08837ca43989b8642bc99a6d97c0560cea14"
    sha256 cellar: :any,                 arm64_big_sur:  "f8caf3278cac4e40b255d362d064ec73ea2f92f0580fa2c34f50165279219c49"
    sha256 cellar: :any,                 ventura:        "d4e96a7ee4204f0e4a230563201bf725de915d560eee4465a18e09ecf8810254"
    sha256 cellar: :any,                 monterey:       "72177ed02a2a3e336775a7e0296f29bbe9923b8a4b3d1a994f9ffd8f29c3d928"
    sha256 cellar: :any,                 big_sur:        "860779b7babd494a2fa8833581bf5b518a7a8ec9c9b9ad7815f33fca52087e57"
    sha256 cellar: :any,                 catalina:       "38b2c487542d1e264b31f560eb582829f178f2aa1abb28ce055475c9dffce9f4"
    sha256 cellar: :any,                 mojave:         "1940f0eb408453bc179cc15c2588ad90eedeef608ec830a10881faee75c00d87"
    sha256 cellar: :any,                 high_sierra:    "e15d0f6129cd4ba502860f0ab0367eceadf2a377be9dd25af30c52ebffd064c6"
    sha256 cellar: :any,                 sierra:         "27f0d95eed42b70eb6685ffe8608465b0f39b88b544dbee080fe3decf81512ed"
    sha256 cellar: :any,                 el_capitan:     "f615e775140216eff74cd0fe751ace5993030c00921574da635a44b41d8bba57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb0169c0f75331b17aedb8d9f54283c5487230015b284429f6a6ee9f72344d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "raptor"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cc, "add_test.c", "-o", "test", "-I#{include}",
                   "-I#{Formula["raptor"].opt_include}/raptor2",
                   "-L#{lib}", "-llrdf"
    system "./test"
    assert_match "<test:id2> <test:foo> \"4\"", File.read("test-out.n3")
  end
end
