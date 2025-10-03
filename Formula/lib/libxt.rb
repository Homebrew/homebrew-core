class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.3.1.tar.xz"
  sha256 "e0a774b33324f4d4c05b199ea45050f87206586d81655f8bef4dba434d931288"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbd5cbf10b36db6b20a4acc72e8fb94c13bd2b8ab908293a52c9be2437b421c2"
    sha256 cellar: :any,                 arm64_sequoia: "c943204935f65bf05b78af5e659996394db0ef2083faac3b8efd58192efb330b"
    sha256 cellar: :any,                 arm64_sonoma:  "1e51d92fb3f1d80f47d7ce82db6152995b8fc91fee571c66673a7ea667048806"
    sha256 cellar: :any,                 arm64_ventura: "7caed6452f24e561e9214d648660a1b9b37db71a7198cf86bac3811f83ec266c"
    sha256 cellar: :any,                 sonoma:        "b4e600308fd42fd1ea790f719e2038f1029fdfbdca9a2010a03e04d3c4c6bbb2"
    sha256 cellar: :any,                 ventura:       "4d2943f42410c3033e727fbcfc38abac5d7a58e3c1c614b9117e9415f448073e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41953b45ae3b9003f04b13697835dae0b60b93f1b66dba27ef030c6993453e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0de9305b6428a6ffca0a8bdb1a777ed01bf9a31cfb91035099a9003cac5598"
  end

  depends_on "pkgconf" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-appdefaultdir=#{etc}/X11/app-defaults
      --disable-silent-rules
      --disable-specs
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/IntrinsicP.h"
      #include "X11/CoreP.h"

      int main(int argc, char* argv[]) {
        CoreClassPart *range;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
