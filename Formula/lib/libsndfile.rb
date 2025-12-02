class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz"
  sha256 "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
  license "LGPL-2.1-or-later"
  revision 1
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7788d515f9bc665779112b28a86810a2ac4bc5fb94a763df5d1188e461efce98"
    sha256 cellar: :any,                 arm64_sequoia: "2d6a8173ef41359c3da4c78a5d5eb402846e480c509b868f671b80a17726f9c4"
    sha256 cellar: :any,                 arm64_sonoma:  "b28dda5bedf544be14e36938d2862ef2f3066a34a85158a50d414deb4a9614f2"
    sha256 cellar: :any,                 arm64_ventura: "a8be24e321ff07f12a3cef98ab42868f44fa507b11dab9c93f0f78936baea171"
    sha256 cellar: :any,                 sonoma:        "ea6ba9a5dc801a8b736ad39a5e417af93c5d0514ea5a741e92da88d9327a7988"
    sha256 cellar: :any,                 ventura:       "3c43fbe437bfd52c5ed12ec4bb3126ca15ffb4c5c189c791ccebf4101d03682a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba22269018452e319778db8f9dfff4f0ddbab0570bd9f44412cf8ea8cccc517a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40061adc0ea00923ea38c2c472eccc172e702398c2ddd3c705bf0dd6b16cbed"
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "opus"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_PROGRAMS=ON
      -DENABLE_PACKAGE_CONFIG=ON
      -DINSTALL_PKGCONFIG_MODULE=ON
      -DBUILD_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON_EXECUTABLE=#{which("python3")}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "static"
    lib.install "static/libsndfile.a"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
