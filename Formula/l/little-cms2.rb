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
    sha256 cellar: :any, arm64_golden_gate: "95b216343a5dce73473576b9ac02283944cf293b0817b48be2d8c19ba78b4cc9"
    sha256 cellar: :any, arm64_tahoe:       "c434b974c1afdc696c5475a743081cda752c842a7645eed54235b874df2b8175"
    sha256 cellar: :any, arm64_sequoia:     "e04ebf2fc43c8ea39680a2255da8b6a7060ee38e5e1f159c8182c6344dd4c679"
    sha256 cellar: :any, arm64_linux:       "40bdf93dd4ade58a731077ee1d75e4962c0b60814270e3dd5722bf7d69eba422"
    sha256 cellar: :any, x86_64_linux:      "32f90320c436dae548b670e659b7108d3a8d508e833d79a77614e9ecd669ce08"
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
