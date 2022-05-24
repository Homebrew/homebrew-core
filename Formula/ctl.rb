class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  # Check whether this can be switched to `openexr` and `imath` at version bump
  url "https://github.com/ampas/CTL/archive/ctl-1.5.2.tar.gz"
  sha256 "d7fac1439332c4d84abc3c285b365630acf20ea041033b154aa302befd25e0bd"
  license "AMPAS"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eadc16c6d81b7d6ac0b4c15954575c3da812903b4af0273eacc5d9b0b7e1d6c9"
    sha256                               arm64_big_sur:  "44e972aad69a12929209b71a8ce3f0cd2c64c3619d38fe8e99f9118dfd231877"
    sha256 cellar: :any,                 monterey:       "cf416b8ac487a6ae5bd3845338e5efdaa9399cfb28c41c1d44d3e520be7af958"
    sha256                               big_sur:        "ff72d9eb8d78bfbc8be7e2df6c5b12ebe84539599f2874df9a63cdeab65d0e93"
    sha256                               catalina:       "348b69fc01982990dc24ba16332bd99851f8fbab4ccd25d05753288f4ff76344"
    sha256                               mojave:         "37dce198f7d3aa8dab4ea3519da23f8a02ffacd61569323d6ee24a9b18c35190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058763c1d8b05ea4a1f1143ef678628d957d96aa0b73f20aac9ff5fff33fe8a6"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "ilmbase"
  depends_on "libtiff"
  depends_on "openexr@2"

  # from https://github.com/ampas/CTL/pull/73
  patch do
    url "https://github.com/ampas/CTL/commit/bda2165b97e512a39ee67cf36fe95e1d897e823b.patch?full_index=1"
    sha256 "09145020a79b180bb8bb8e18129194b064d4c8a949940fb97be4945b99b06d7f"
  end

  # from https://github.com/ampas/CTL/pull/74
  patch do
    url "https://github.com/ampas/CTL/commit/0646adf9dcf966db3c6ec9432901c08387c1a1eb.patch?full_index=1"
    sha256 "5ec79eed7499612855d09d7bb18a66a660b6be9785fdfcc880d946f95fb7a44c"
  end

  def install
    ENV.cxx11
    ENV.delete "CTL_MODULE_PATH"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
