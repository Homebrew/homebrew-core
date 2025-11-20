class Libxspf < Formula
  desc "C++ library for XSPF playlist reading and writing"
  homepage "https://libspiff.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libspiff/Sources/1.2.1/libxspf-1.2.1.tar.bz2"
  sha256 "ce78a7f7df73b7420b6a54b5766f9b74e396d5e0b37661c9a448f2f589754a49"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "211b569e374951a2f546836312639bf1aa937ecbf4426147663d57e4fded5f2b"
    sha256 cellar: :any,                 arm64_sequoia:  "f89d8d32a4bfb4ceb5254b1bd40d8bbb6ad1363143c1897a4ad945664b39b70d"
    sha256 cellar: :any,                 arm64_sonoma:   "ebe5a694ae5d6433a1d632e780572da1e4addcbcf871370c85ed928e2e6feed1"
    sha256 cellar: :any,                 arm64_ventura:  "03f9d06101c08ff9f642fcdd03f4983b97c85191fb8b9476e0dbda13c9488914"
    sha256 cellar: :any,                 arm64_monterey: "c3200ce73e78aff6e49838294213ed76c255d451fdc2a16b7afdf726a4113cc8"
    sha256 cellar: :any,                 arm64_big_sur:  "46c96c913b55106e3d616a0cae41b628bedea1b1226f757ab69505d85a773f38"
    sha256 cellar: :any,                 sonoma:         "fe379ee49349f8cbcb67c944ab9605e30a25a3007385eaae802626a252f5b522"
    sha256 cellar: :any,                 ventura:        "e904f629cf88a4df489149100af8a60ffb9ef12e1fef74651095e0d57f54d48e"
    sha256 cellar: :any,                 monterey:       "fbeb2b06f536534acd8e85c7cd86b0603f85e059dfb0277cf093c4aeb5875dca"
    sha256 cellar: :any,                 big_sur:        "3bdd88ce60539e5c451fbfbb39d85719b9551965550b5b2937f409f152b08330"
    sha256 cellar: :any,                 catalina:       "e0047524231105d369ade5acf8110d3e64f5d98f39848df201cfcdc9ded7ec39"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2e7ee0f7026c5cfe6bbf84efc5474a94274645bdd0e7a498c20e5b6a37e21a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e901fd286da4e617543de36efef5f7e0a115d936eeb3ec01326ae92a02df29d8"
  end

  depends_on "cpptest" => :build
  depends_on "pkgconf" => :build
  depends_on "uriparser"

  uses_from_macos "expat"

  resource "check.cpp" do
    url "https://gitlab.xiph.org/xiph/libxspf/-/raw/master/examples/check/check.cpp"
    sha256 "fdd1e586c4f5b724890eb2ce6a3cd3b9910a8e74ee454fe462ba8eb802f7c4b9"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("check.cpp").stage(testpath)
    flags = "-I#{include} -L#{lib} -lxspf".split
    system ENV.cxx, "check.cpp", "-o", "check", *flags
  end
end
