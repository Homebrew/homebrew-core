class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "https://www.argyllcms.com/"
  url "https://www.argyllcms.com/Argyll_V2.1.2_src.zip"
  sha256 "be378ca836b17b8684db05e9feaab138d711835ef00a04a76ac0ceacd386a3e3"
  license "AGPL-3.0-only"

  livecheck do
    url "https://www.argyllcms.com/downloadsrc.html"
    regex(/href=.*?Argyll[._-]v?(\d+(?:\.\d+)+)[._-]src\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "5e8e8a930085732ca5c9b8a2d1c17a3e061a2c0ec808e012cc66a7b1606c8b89"
    sha256 cellar: :any, big_sur:       "4b35f61daa05c91346c27c6c51a18f3cff08569a70e7520abb93772c6a09fe83"
    sha256 cellar: :any, catalina:      "e2d28da901faf4c20dc5269a79676cbf4b0a188e0d007100d8bb3945f41c31bc"
    sha256 cellar: :any, mojave:        "6d5f4584dcbe74982cae2cd8d6162fa27d332508deb7414e9a22f473ac3479d0"
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  conflicts_with "num-utils", because: "both install `average` binaries"

  # Fixes calls to obj_msgSend, whose signature changed in macOS 10.15.
  # Follows the advice in this blog post, which should be compatible
  # with both older and newer versions of macOS.
  # https://www.mikeash.com/pyblog/objc_msgsends-new-prototype.html
  # Submitted upstream: https://www.freelists.org/post/argyllcms/Patch-Fix-macOS-build-failures-from-obj-msgSend-definition-change
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6ede0dff06c2d9e3383416dc57c5157704b6f3a/argyll-cms/fix_objc_msgSend.diff"
    sha256 "fa86f5f21ed38bec6a20a79cefb78ef7254f6185ef33cac23e50bb1de87507a4"
  end

  # Fixes a missing header, which is an error by default on arm64 but not x86_64
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6ede0dff06c2d9e3383416dc57c5157704b6f3a/argyll-cms/unistd_import.diff"
    sha256 "5ce1e66daf86bcd43a0d2a14181b5e04574757bcbf21c5f27b1f1d22f82a8a6e"
  end

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 to graeme AT argyllcms DOT com
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "numlib/numsup.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
    end

    # These two inreplaces make sure /opt/homebrew can be found by the
    # Jamfile, which otherwise fails to locate system libraries
    inreplace "Jamtop", "/usr/include/x86_64-linux-gnu$(subd)", "#{HOMEBREW_PREFIX}/include$(subd)"
    inreplace "Jamtop", "/usr/lib/x86_64-linux-gnu", "#{HOMEBREW_PREFIX}/lib"
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each do |f|
      assert_predicate testpath/f, :exist?
    end
    assert_match "Calibrate a Display", shell_output("#{bin}/dispcal 2>&1", 1)
  end
end
