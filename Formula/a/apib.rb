class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/refs/tags/APIB_1_2_1.tar.gz"
  sha256 "e47f639aa6ffc14a2e5b03bf95e8b0edc390fa0bb2594a521f779d6e17afc14c"
  license "Apache-2.0"
  head "https://github.com/apigee/apib.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "337cb9a61b2d654dd1217f9abb5c6b36056b0a9a1b0309493761e48b70e3c087"
    sha256 cellar: :any,                 arm64_sequoia:  "16bdbdc8c1157d81ef431aa3c9065d08a8986f6f9863d6d1d9ec7b9bf9ba1a4c"
    sha256 cellar: :any,                 arm64_sonoma:   "6b82511a66880598cbb30560c46652203f7448dd5fecea99bf50a73cc248f18a"
    sha256 cellar: :any,                 arm64_ventura:  "0d3f8ebb9f43ccdebb3d1f0afea5decb6418aee36e2021d8c6eb2a182f023c09"
    sha256 cellar: :any,                 arm64_monterey: "c411bb84a6c9cedada2763065efefa16107e3d030108a0a56d58cbef1261ead7"
    sha256 cellar: :any,                 arm64_big_sur:  "a2c0d222e5f4e7ce13ea2671367e125a2a493922696f1cdcccf01edb3fcafb8f"
    sha256 cellar: :any,                 sonoma:         "8312ece497888c99b07749e20beb873192dcc2ccc16cd0f0f0193324e9bec9f1"
    sha256 cellar: :any,                 ventura:        "829fdf8369067c69644601156922fa6f2a6b42909156c5760c9b37a0cfaf3a72"
    sha256 cellar: :any,                 monterey:       "f8b39236e548bc511ac9be750bf5e34ea153828b66fee23f12d59cef6a1d2459"
    sha256 cellar: :any,                 big_sur:        "26096e8f935082051fb8695d3f01ae9d0991baad89d170d96461794a9f756d3a"
    sha256 cellar: :any,                 catalina:       "c14c342e3615bce14f3fe666fefdd17456e1c96b5ce8b59edd46dad19beab49f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f95d7ee859f9339c976338e990352bf0416c79a14645c66eda6ee7387f4089b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43509a772521b80a03d3702dba034b752371581c0739c6cfb7f1c48217398a42"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "openssl@3"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "apib", "apibmon"
    bin.install "build/apib/apib", "build/apib/apibmon"
  end

  test do
    system bin/"apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
