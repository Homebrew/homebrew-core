class Lrdf < Formula
  desc "RDF library for accessing plugin metadata in the LADSPA plugin system"
  homepage "https://github.com/swh/LRDF"
  url "https://github.com/swh/LRDF/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d579417c477ac3635844cd1b94f273ee2529a8c3b6b21f9b09d15f462b89b1ef"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c09fe231441b197696150fc815ddabbcad7a895048555bf374f2064eaf277d09"
    sha256 cellar: :any,                 arm64_sequoia:  "e4f7f5611084a0b10affb934cbec578c9b021da49d439b605539da12666ee47c"
    sha256 cellar: :any,                 arm64_sonoma:   "2088f2cfbf3cac00eccd96cc9b7afdc8462d2e8a8e191cd2832f476270fd6daa"
    sha256 cellar: :any,                 arm64_ventura:  "8a0af2e4b47ceacad5f819b793adc705ffa969031d21959cfa415f5d94ab6899"
    sha256 cellar: :any,                 arm64_monterey: "a335b0fe4f73626b825bae7a510a08837ca43989b8642bc99a6d97c0560cea14"
    sha256 cellar: :any,                 arm64_big_sur:  "f8caf3278cac4e40b255d362d064ec73ea2f92f0580fa2c34f50165279219c49"
    sha256 cellar: :any,                 sonoma:         "ea821b325e68ec373f605f434dc4bf99fa2ecc98dee3a1c4fa7b28051ab2e183"
    sha256 cellar: :any,                 ventura:        "d4e96a7ee4204f0e4a230563201bf725de915d560eee4465a18e09ecf8810254"
    sha256 cellar: :any,                 monterey:       "72177ed02a2a3e336775a7e0296f29bbe9923b8a4b3d1a994f9ffd8f29c3d928"
    sha256 cellar: :any,                 big_sur:        "860779b7babd494a2fa8833581bf5b518a7a8ec9c9b9ad7815f33fca52087e57"
    sha256 cellar: :any,                 catalina:       "38b2c487542d1e264b31f560eb582829f178f2aa1abb28ce055475c9dffce9f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7ebc904f67f824e682d13f0ca1f0176c17b8aadcea4270c1cf476a4bcfd40835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb0169c0f75331b17aedb8d9f54283c5487230015b284429f6a6ee9f72344d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "raptor"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
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
