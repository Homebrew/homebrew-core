class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ee4e8e386dbf585e9672aabb460e44e0a3ba40486d71443200912c1e39e95ad5"
    sha256 cellar: :any,                 arm64_monterey: "63cf0b6889738999549fbaec92d5a6659c7e67243e6c1d8c6de327a625aec770"
    sha256 cellar: :any,                 arm64_big_sur:  "462e0b0b6d802d8b63a5179525830a7a2b653e508447c3a3c6c1e49fa644e173"
    sha256 cellar: :any,                 ventura:        "4719aeb4e527d69dec4a39e3ebd572f5e3a75997771fa7bdb7b95d8ef1a0d52c"
    sha256 cellar: :any,                 monterey:       "c947cdf5337bf9b01d58bfab17640121972ecda945c19142296d94738a7a637a"
    sha256 cellar: :any,                 big_sur:        "680680ea8ab91083953e359b7fb74bd8195e4d9c94fdb3c351741d90983f72c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542fd495cbe83aed52b7766926946f923d1e395f46cb4245b6ac6387cbeb0276"
  end

  disable! date: "2024-09-16", because: :repo_removed

  depends_on "openssl@3"
  depends_on "python@3.11"

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/commit/1d76a269d18319ea3cc9123901ea8cf240f7cc34.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  # Fix compatibility with Python 3.10 and later.
  # SystemError: PY_SSIZE_T_CLEAN macro must be defined for '#' formats
  # PR ref: https://github.com/bwall/HashPump/pull/25
  patch :DATA

  def python3
    "python3.11"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}", "install"
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' " \
                          "-d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' " \
                          "-a '&waffle=liege' -k 14")
    assert_match "0e41270260895979317fff3898ab85668953aaa2", output
    assert_match "&waffle=liege", output
    assert_equal 0, $CHILD_STATUS.exitstatus

    (testpath/"test.py").write <<~EOS
      import hashpumpy
      print(hashpumpy.hashpump('ffffffff', 'original_data', 'data_to_add', len('KEYKEYKEY'))[0])
    EOS
    assert_equal "e3c4a05f", shell_output("#{python3} test.py").chomp
  end
end

__END__
diff --git a/hashpumpy.cpp b/hashpumpy.cpp
index e84e442..eaa9f04 100644
--- a/hashpumpy.cpp
+++ b/hashpumpy.cpp
@@ -1,3 +1,4 @@
+#define PY_SSIZE_T_CLEAN
 #include <Python.h>
 #include <sstream>
 #include <iomanip>
