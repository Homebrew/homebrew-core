class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  license "GPL-3.0-or-later"

  stable do
    # TODO: Update to use Qt 6 in next release and remove planned deprecation
    url "https://github.com/miek/inspectrum/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "94e42333aceb06c15fb6fc10d186d61112975fdcf9539357a279e886e9edf35e"

    depends_on "qt@5"

    # Backport fix for CMake 4
    patch do
      url "https://github.com/miek/inspectrum/commit/456ce147f3af4e1fb191b422954eeeaa9b807fdb.patch?full_index=1"
      sha256 "98803885e8088a0ba468044f3d84e970d6a0bea121e1eebdcc9be553aff3765a"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "01c5abe179e48ef0e3c9b8b4023c809b8a562edc17dc6b62acc4404f9fdf2bc4"
    sha256 cellar: :any,                 arm64_sequoia:  "7060c870cf3c1fb749f7fbca5fa9479ff9f3794f932804f211728c6238355025"
    sha256 cellar: :any,                 arm64_sonoma:   "b8fed8bc9e251d6f90e191b260fba14a907183b966ce9058eca5e45832fd096b"
    sha256 cellar: :any,                 arm64_ventura:  "85676ab09338e0dc82b50ef359f7ac49e8f1ae09eaa673ad23da5edb55dcbe07"
    sha256 cellar: :any,                 arm64_monterey: "a4a8b084973fc6d26f895e56e82e3bb5b6f10ef5f803a2ae41b85ecd7e84d06f"
    sha256 cellar: :any,                 sonoma:         "d362f00903bb5068748061931788f911ecc8f219453822eb5e2dbfbefbe77e7d"
    sha256 cellar: :any,                 ventura:        "4698d8a738a586230abc96eafdf2b8e5ddc404eed157a9793232742c60689f0d"
    sha256 cellar: :any,                 monterey:       "dd6e9a06f5bb1a627906d9b87b5f2a54c0589f9663335224092eed9d4ec8e038"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dc6d00d7c08d2827e7c767d714e052a5b005183b9ca7febbce13cbb8c605471e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd0cb2283b88fad36bb8c481cab44ee8fa12be897a798697d3643646772cf4c"
  end

  head do
    url "https://github.com/miek/inspectrum.git", branch: "main"

    depends_on "qtbase"
  end

  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "liquid-dsp"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # inspectrum is a GUI application
    assert_match "-r, --rate <Hz>     Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
