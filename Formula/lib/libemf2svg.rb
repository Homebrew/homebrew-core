class Libemf2svg < Formula
  desc "Microsoft (MS) EMF to SVG conversion library"
  homepage "https://github.com/kakwa/libemf2svg"
  url "https://github.com/kakwa/libemf2svg/archive/refs/tags/1.1.0.tar.gz"
  sha256 "ad48d2de9d1f4172aca475d9220bbd152b7280f98642db561ee6688faf50cd1e"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "adf093b34e21931b3ef18d375f067f7b725684ee2c1c2326f47136e0ff7d8838"
    sha256 cellar: :any,                 arm64_sequoia:  "c769ed043dc565d050ee360ed38753a5f09db7fb39987c295c3d08b3eba16834"
    sha256 cellar: :any,                 arm64_sonoma:   "46974d67b425299521f648acc2561051646afbb51e47d45ff954277df5b32334"
    sha256 cellar: :any,                 arm64_ventura:  "1fc992a4391b5890a2163b4019c36331fb462f79a0fc77bfeb4c06e5a4641d73"
    sha256 cellar: :any,                 arm64_monterey: "5c433d7a620912bb39e0a09a8f9d793028bf6c671a716d8e6f7f63cdf797aaa9"
    sha256 cellar: :any,                 arm64_big_sur:  "063dce921f40a941dccf3d79c1e886dc9944bda2166b9a840f5a6a80d37ffb6d"
    sha256 cellar: :any,                 sonoma:         "bb3ba1207ae1a563746eda8b4cae2fa6eede0a19077cd562cadb31d56f747f78"
    sha256 cellar: :any,                 ventura:        "e70b11b9736140938aac03fe053af3312cb992cc7aeb3a5a48573c2fd1b4eb69"
    sha256 cellar: :any,                 monterey:       "282508d66b3fd198648a798040205d7f3e42720cc9fc64572ac397767b369851"
    sha256 cellar: :any,                 big_sur:        "2da6c337708d8666ddfd4295b77f81b72c099f31c564f4efd79bed5f620a0d7a"
    sha256 cellar: :any,                 catalina:       "22a0d2002ff89d8583fa86c103d465b23fe7809a527aae4c6dad29b39db020f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "06d60d5e8329cb81fa95b4ffc2253df5e29c98106b08e07248adaf811df48605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "271caea2750597c1a8f0b30b80f4cdd901c439db73ca0d179420a0e3cb12c4bc"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    args = %W[-DCMAKE_INSTALL_RPATH=#{rpath}]
    # Workaround for CMake 4 compatibility
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/kakwa/libemf2svg/raw/1.1.0/tests/resources/emf/test-037.emf"
      sha256 "d2855fc380fc3f791da58a78937af60c77ea437b749702a90652615019a5abdf"
    end

    resource("homebrew-testdata").stage do
      system bin/"emf2svg-conv", "-i", "test-037.emf", "-o", testpath/"test.svg"
    end
    assert_path_exists testpath/"test.svg"
  end
end
