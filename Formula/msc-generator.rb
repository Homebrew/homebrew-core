class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/7.3.1/msc-generator-7.3.1.tar.gz"
  sha256 "ee715cb0a9ca16d218d5092d6f9e4a2fa5366489beb03c9c65b03293d3c8e56a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "901294bc54e8da0986e3e0b4e1ffc0707d2f503639914187d54cd0379218b064"
    sha256 arm64_big_sur:  "f65ba879ff561f20c4604522c07e09ab00a83862480038d45cb2cf8b79692757"
    sha256 monterey:       "eecd90f08041a878eb775d1baebdf20efbf47f159d36b180d46de1cc9f1058c1"
    sha256 big_sur:        "3fb9534c7e43ec8e80f852840356749feefd1f370a259bd58b9ba32b57c652a6"
    sha256 catalina:       "e1d2f7b436ce2038ab041e244f0b7de89584741db47b4325aeff246f797d4bba"
    sha256 x86_64_linux:   "9ddfb8e582742435e1a56d6751ec8b817264041f99812a0302748385d80f0647"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  def install
    system "./configure", *std_configure_args, "--disable-font-checks"
    system "make", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
