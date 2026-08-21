class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.net/"
  url "https://github.com/dharple/detox/releases/download/v3.0.1/detox-3.0.1.zip"
  sha256 "425a02fda04103b86abe7f83bdd4c73de5c9c9f69041fb16e9e2e602dd78495b"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5b6cc3ec164a49aed7f74a057dcdfc0624039b5e45ee862b14b0a3572924108a"
    sha256 arm64_sequoia: "6bcebbdd9744891565b47598137c74cb2fa3575fed2e7986ecfa4c84d28d6d33"
    sha256 arm64_sonoma:  "7a35155bc47105a81f7d8686d81c6f57132e818e23b1826a9e0db9ba99c5485e"
    sha256 sonoma:        "5bcabd0395a399adf629b26333fecdf7bc24b03df64d936f0d67fea8f2b7c0b6"
    sha256 arm64_linux:   "054d30874e4052a461ad114b71b7f287ca2e7d97ffda99dde8eaa903be968b8c"
    sha256 x86_64_linux:  "7da903d78cb34df0994b78c8a32fa31a66738d714f96af4631859ff93414da28"
  end

  deprecate! date: "2026-07-28", because: :unmaintained

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
