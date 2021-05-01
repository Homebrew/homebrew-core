class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.2.tar.gz"
  sha256 "c9e8630cf9d433f3cead74906a1520d2223f89bcd3fa9254861017440b8eb22f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "90dee33598510f7bca41e3da463e18f5400d71639af4394668ade28b89dc6175"
    sha256 cellar: :any, big_sur:       "aacfb5ad63c65fd2a2de00ce2bb20e2b620b26e21e9c76cafbf967327d03a49d"
    sha256 cellar: :any, catalina:      "526c83a79b7f208f07e8d04ad5ce47c8104d90a76034e42422d124fba128ba3c"
    sha256 cellar: :any, mojave:        "9353da38e4b43913964f9cdc5fc2a28c4b6c0a19ceef4e2a58db62ba3fdb4d49"
    sha256 cellar: :any, high_sierra:   "a8812e355f28272c7d8153bcda0e48a58c0bd0a880ed0256a2bc460143d1df78"
  end

  head do
    url "https://git.code.sf.net/p/opencore-amr/fdk-aac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system "#{bin}/aac-enc", test_fixtures("test.wav"), "test.aac"
    assert_predicate testpath/"test.aac", :exist?
  end
end
