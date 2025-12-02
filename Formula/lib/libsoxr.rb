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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "6fd815529e1078139d7965e7bb7e92b4fa5680e74ca671357aaf4c0e1ea1dc95"
    sha256 cellar: :any,                 arm64_sequoia:  "164c5e70f213a0cdd5b9a764da773e79bc35753efc54d46e0710aee172de3640"
    sha256 cellar: :any,                 arm64_sonoma:   "baddfdda71b784b3d94f84e9f7a1b8bcfec59762baddf9e3ccc67c19fb41cee0"
    sha256 cellar: :any,                 arm64_ventura:  "458c15f8d4dbe92d51959fd62662b275475c36f379581385681975fbba90c8f1"
    sha256 cellar: :any,                 arm64_monterey: "dd14558c84be8ea6b19408a9e3c59cb273b19334fb59220e8681315507d867ed"
    sha256 cellar: :any,                 arm64_big_sur:  "cf7ef980c9553756fa4b267b52e940566dc07b9aecbfea49180dbb2ebdeb433a"
    sha256 cellar: :any,                 sonoma:         "00d2a5318828b9120aaa460510b5d23edee43f1e5db04cf74ba12a3908642d3c"
    sha256 cellar: :any,                 ventura:        "530b083606fb1bd4801d7364ba55607304c5c89696d82dcc8a7a5482d73f192c"
    sha256 cellar: :any,                 monterey:       "f1a61556ee8195d611cdf735cad6f36a841cf8ef66fe5e49030b8932cd73033d"
    sha256 cellar: :any,                 big_sur:        "616e7ec0eac9aa1322b9c32a1e2ba71ce18c36ee9cbfc854b43c77153006c142"
    sha256 cellar: :any,                 catalina:       "6fc775411464312fe93dff80cf50497d7b412b36c8115eaa91fe65c321da755e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "41860cff8cb688bff751be3d79c39e2dff0c0be2e2196b700386aca27b65769b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1753c0562a6494e1437dc79db88d4672bb4b2e2a2b9134ac85952b555baf8559"
  end

  depends_on "cmake" => :build

  # Fixes the build on 64-bit ARM macOS; the __arm__ define used in the
  # code isn't defined on 64-bit Apple Silicon.
  # Upstream pull request: https://sourceforge.net/p/soxr/code/merge-requests/5/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libsoxr/arm64_defines.patch"
    sha256 "9df5737a21b9ce70cc136c302e195fad9f9f6c14418566ad021f14bb34bb022c"
  end

  def install
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "-L#{lib}", "test.c", "-lsoxr", "-o", "test"
    system "./test"
  end
end
