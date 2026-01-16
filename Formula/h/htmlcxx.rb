class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "https://htmlcxx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htmlcxx/v0.87/htmlcxx-0.87.tar.gz"
  sha256 "5d38f938cf4df9a298a5346af27195fffabfef9f460fc2a02233cbcfa8fc75c8"
  license all_of: ["LGPL-2.0-only", "Apache-2.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "8d731c143f491da872ee21c1ea5b39b216113ceab22b26212e1b249edce7b0c1"
    sha256 arm64_sequoia:  "e1cb2639240425d10dcaea3639f09ae7b7795141d85b562d5df0fd79709c6edc"
    sha256 arm64_sonoma:   "a0db079df456a6240676663a280b60f12ef280c2a83f3f4a3a7c41a9e5bd719d"
    sha256 arm64_ventura:  "a89f6f97c7cdaa4ad3734786c0a15c2bbbfd6ba703127c9239bff75e89ace62a"
    sha256 arm64_monterey: "f0b1e84a587e9c944b7e6d1952b1feea22e223897a12adf51e28f51ec9bf4e9d"
    sha256 arm64_big_sur:  "076a461f50d225b8f6d7b1d1541b0fcdb2fba0af77e28d2524815e5d912b623e"
    sha256 sonoma:         "65361151ac13372109b4cda9bb852c32b6d53ffbeb8cdbe04aabf85671ac61bc"
    sha256 ventura:        "61b23db961d207a125bb6443e2d76d9e2a4d8d89443165c385962be172ed8c09"
    sha256 monterey:       "2f62b3bfd180f22804cf7df3161f018769be76311e4d740cc619f3fb2766a1aa"
    sha256 big_sur:        "5afe59e8f11f3ee3d04448c1e885b433cdcb356c6aaa80bc1e8ed0f6b0c0ec95"
    sha256 catalina:       "8414d919ae850983832803af525e8b98d3e5aa106c47b05f420d77020c7c99ca"
    sha256 arm64_linux:    "6302595c7cf05e040aa5cfbfec3b91408e5c6769f4117a2e7d8d0103c9e492a2"
    sha256 x86_64_linux:   "ba29d98077036799d68c6c6dc56e0e7fa28aee700a89f4128a2d10a29d1ab39e"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/htmlcxx -V 2>&1").chomp
  end
end
