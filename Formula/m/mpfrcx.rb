class Mpfrcx < Formula
  desc "Arbitrary precision library for arithmetic of univariate polynomials"
  homepage "https://www.multiprecision.org/mpfrcx/"
  url "https://www.multiprecision.org/downloads/mpfrcx-0.6.3.tar.gz"
  sha256 "9da9b3614c0a3e00e6ed2b82fc935d1c838d97074dc59cb388f8fafbe3db8594"
  license "GPL-3.0-or-later"
  head "https://gitlab.inria.fr/enge/mpfrcx.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0040f42d09efca8b3d759eb4b6f52158d89edbd1019d4919152d56666eb9de81"
    sha256 cellar: :any,                 arm64_sequoia:  "e9d9fcb8796dc03e08d4f3b1d1e6e1cd054befac43f75f20f6592891e01c366f"
    sha256 cellar: :any,                 arm64_sonoma:   "3943e6b49295761e2d5ca64145d1f0ca80255d0d6c608c1dc2df5c8d964a9c55"
    sha256 cellar: :any,                 arm64_ventura:  "0525d37742602a124d2bc1631cf9d201d0e2d88002b57257ddb444d8407b5ac8"
    sha256 cellar: :any,                 arm64_monterey: "c10ab1b46750109d8d957074a1d876176b9e05c246c76302a4c88bf35a6ddc52"
    sha256 cellar: :any,                 arm64_big_sur:  "a46ef1e2ec99e097e239ba509d765b00dcd6af1176abeba16e24c415bef80897"
    sha256 cellar: :any,                 sonoma:         "66c8164a31ba3594d87f7cb29062b9562413cc71adc90ba96178cb630f4b332a"
    sha256 cellar: :any,                 ventura:        "d9f53f55c7a8931e03c5a8adbd8f4d15396b3ac4b90fef67df9646fb127fb86a"
    sha256 cellar: :any,                 monterey:       "2a8d8afb5038289d4bb3b6641dd4362369d09c3c370c2a682aa09d726854d8f9"
    sha256 cellar: :any,                 big_sur:        "6cbcd65b4fe55b4be169457f4a915bd60a52a4ded61af56b0d0e67bcf8863685"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e9fb25f1f4406a9aa90110ef908ccfb58c4fa3c08bfc37bbdc8aeb59994c7ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4bc73f687ec7bb72c060eb35acc89a2eefd1aa46d706a177a13bee6245cde0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    # Regenerate configure to avoid building libraries with flat namespaces
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    (pkgshare/"tests").install Dir["tests/tc_*.c"]
  end

  test do
    Dir[pkgshare/"tests/*"].each do |src|
      testname = File.basename(src, ".c")
      system ENV.cc, src, "-I#{include}", "-L#{lib}",
             "-L#{Formula["gmp"].opt_lib}", "-L#{Formula["libmpc"].opt_lib}", "-L#{Formula["mpfr"].opt_lib}",
             "-lmpfrcx", "-lgmp", "-lmpc", "-lmpfr",
             "-o", testname
      system testpath/testname
    end
  end
end
