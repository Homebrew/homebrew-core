class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://sourceforge.net/p/lcms/mailman/lcms-user/
  # Ref: https://github.com/mm2/Little-CMS/issues/569#issuecomment-4414911319
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.20/lcms2-2.20.tar.gz"
  sha256 "18ff5504fa9cc8a2b1f3591180d90ead16c8a2ea78e530523b46eab70e1ca6b9"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7bb337d2d9d577c7295721ba602ed5b49673f5285fbd359918b102ed363b3af9"
    sha256 cellar: :any, arm64_tahoe:       "11f9fcdcbbe77b186777196971d8ba2c41526d2d96fbd02d411461df73313dce"
    sha256 cellar: :any, arm64_sequoia:     "f68c3c93b9ee63891388f6485b27c5bc2605638df36b4806bdc52f0636e8254b"
    sha256 cellar: :any, arm64_sonoma:      "823125475a9f5bfd1f2ddda2910143aa47c018c4cd6c55867b7461553d1719e1"
    sha256 cellar: :any, arm64_linux:       "552eb0eadd3bf6059bdf16961bc30027ea11cf1d42a75f56f06403f10d14914b"
    sha256 cellar: :any, x86_64_linux:      "16489b671db41055ab7066193482ef9812f5eb970110eec86bd0a40620a48c49"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/lcms2.pc", prefix, opt_prefix
  end

  test do
    system bin/"jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
