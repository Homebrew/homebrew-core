class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.3-Source.tar.xz"
  sha256 "b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/soxr[._-]v?(\d+(?:\.\d+)+)(?:-Source)?\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "dd14558c84be8ea6b19408a9e3c59cb273b19334fb59220e8681315507d867ed"
    sha256 cellar: :any,                 arm64_big_sur:  "cf7ef980c9553756fa4b267b52e940566dc07b9aecbfea49180dbb2ebdeb433a"
    sha256 cellar: :any,                 monterey:       "f1a61556ee8195d611cdf735cad6f36a841cf8ef66fe5e49030b8932cd73033d"
    sha256 cellar: :any,                 big_sur:        "616e7ec0eac9aa1322b9c32a1e2ba71ce18c36ee9cbfc854b43c77153006c142"
    sha256 cellar: :any,                 catalina:       "6fc775411464312fe93dff80cf50497d7b412b36c8115eaa91fe65c321da755e"
    sha256 cellar: :any,                 mojave:         "ddd19b9146079827cd9065afe6853961e8b0d0857f5a06888efc500a25f087e6"
    sha256 cellar: :any,                 high_sierra:    "808ad13bdf13729d2f7e881c34b267bcd6598838d4f47d0dcf5ca5e38ba5db9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1753c0562a6494e1437dc79db88d4672bb4b2e2a2b9134ac85952b555baf8559"
  end

  depends_on "cmake" => :build

  # Fixes the build on 64-bit ARM macOS; the __arm__ define used in the
  # code isn't defined on 64-bit Apple Silicon.
  # Upstream pull request: https://sourceforge.net/p/soxr/code/merge-requests/5/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/76868b36263be42440501d3692fd3a258f507d82/libsoxr/arm64_defines.patch"
    sha256 "9df5737a21b9ce70cc136c302e195fad9f9f6c14418566ad021f14bb34bb022c"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <soxr.h>

      int main()
      {
        char const *version = 0;
        version = soxr_version();
        if (version == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lsoxr", "-o", "test"
    system "./test"
  end
end
