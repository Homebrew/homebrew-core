class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.1.tar.gz"
  sha256 "840133aa9412153894af03b27b03dde1188772442c316a4ce2a24ed70093f271"

  bottle do
    cellar :any
    sha256 "526c83a79b7f208f07e8d04ad5ce47c8104d90a76034e42422d124fba128ba3c" => :catalina
    sha256 "9353da38e4b43913964f9cdc5fc2a28c4b6c0a19ceef4e2a58db62ba3fdb4d49" => :mojave
    sha256 "a8812e355f28272c7d8153bcda0e48a58c0bd0a880ed0256a2bc460143d1df78" => :high_sierra
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
