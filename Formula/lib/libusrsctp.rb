class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sctplab/usrsctp.git", branch: "master"

  stable do
    url "https://github.com/sctplab/usrsctp/archive/refs/tags/0.9.5.0.tar.gz"
    sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"

    # Fix minimum required version to configure with CMake 4
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/sctplab/usrsctp/commit/7569d2ce1e8658534369ad9726ca62139211db84.patch?full_index=1"
      sha256 "6d37314f524ff301546f1e53b605dd276837a984545c6dc1cb21ad87cbd49f6b"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "6103700921dd7e4269e9cd22540acc5d28e30e3ca10a3aa57aa75bf5f05c9378"
    sha256 cellar: :any,                 arm64_sequoia:  "26779b22a8b35e70131a4fb010839955453e8d703f682d77b411c5900d2543ab"
    sha256 cellar: :any,                 arm64_sonoma:   "d87af9c75847214b4101934141dd53dc3e5992304bd8f97aace95c683a2fa435"
    sha256 cellar: :any,                 arm64_ventura:  "27f59644b7711afcde95e34c6258a4f62bedaff91e7de90356494a511fa85f35"
    sha256 cellar: :any,                 arm64_monterey: "5aebfe223f88de1bd4b8177d85a4034f819c9957f2f56292e8961ea52af1f20c"
    sha256 cellar: :any,                 arm64_big_sur:  "55d87963abae2a23d3f13644ce478a08c05a929a5619ff5d3db24c3758873520"
    sha256 cellar: :any,                 sonoma:         "55c6cbd763cd6733dde2c9cd09185aaae980d4ec5b6fe509fb707100fcae8400"
    sha256 cellar: :any,                 ventura:        "a99c35127a48fb9bfbd02e75741938b4bfe4f7ada7c53692fc944e2a316fa72a"
    sha256 cellar: :any,                 monterey:       "574a2ddedf60e11662a1ba899019334390bcc5b3ef8a789fe9feec7f32974b77"
    sha256 cellar: :any,                 big_sur:        "8c7e338e82252ed7aa5ac2ac8d007f70d998d428dd713a1bc9e57fa7c483d004"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "32b23193aec4c98b68aed3e46c9d09ed6e924a3cc0ef1aa567dbe749fc92363a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed390a46abf6f2244181acd53fafe4280a4b0f41e07720e3161d27995b0cbff"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsctp_build_shared_lib=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-lpthread", "-o", "test"
    system "./test"
  end
end
