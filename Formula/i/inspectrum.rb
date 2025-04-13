class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "94e42333aceb06c15fb6fc10d186d61112975fdcf9539357a279e886e9edf35e"
  license "GPL-3.0-or-later"
  head "https://github.com/miek/inspectrum.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7060c870cf3c1fb749f7fbca5fa9479ff9f3794f932804f211728c6238355025"
    sha256 cellar: :any,                 arm64_sonoma:   "b8fed8bc9e251d6f90e191b260fba14a907183b966ce9058eca5e45832fd096b"
    sha256 cellar: :any,                 arm64_ventura:  "85676ab09338e0dc82b50ef359f7ac49e8f1ae09eaa673ad23da5edb55dcbe07"
    sha256 cellar: :any,                 arm64_monterey: "a4a8b084973fc6d26f895e56e82e3bb5b6f10ef5f803a2ae41b85ecd7e84d06f"
    sha256 cellar: :any,                 sonoma:         "d362f00903bb5068748061931788f911ecc8f219453822eb5e2dbfbefbe77e7d"
    sha256 cellar: :any,                 ventura:        "4698d8a738a586230abc96eafdf2b8e5ddc404eed157a9793232742c60689f0d"
    sha256 cellar: :any,                 monterey:       "dd6e9a06f5bb1a627906d9b87b5f2a54c0589f9663335224092eed9d4ec8e038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebd0cb2283b88fad36bb8c481cab44ee8fa12be897a798697d3643646772cf4c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qt@5"

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
