class Arss < Formula
  desc "Analyze a sound file into a spectrogram"
  homepage "https://arss.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arss/arss/0.2.3/arss-0.2.3-src.tar.gz"
  sha256 "e2faca8b8a3902226353c4053cd9ab71595eec6ead657b5b44c14b4bef52b2b2"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bfe57aa3bd356a8a7d3b616e96f854b484a92be45620cbf9ce3729a7ded493bb"
    sha256 cellar: :any,                 arm64_sequoia:  "02051c251dcf51557823a6ae6effb432c9c892a42a3ab19e80c9b8f0e61327ad"
    sha256 cellar: :any,                 arm64_sonoma:   "b0bf1ad20a051b16f65fbbe1ee4780b674ae2a12953291e51de2ca4fd1d478d8"
    sha256 cellar: :any,                 arm64_ventura:  "8daf9486dc32c8698fa1fb731ceb12b04d00019043a803803a71e7472a0781ee"
    sha256 cellar: :any,                 arm64_monterey: "89e8bfca3e620702bbf44ad9f75dcf18c48ef90b5ea97709a657be4cf15e6d25"
    sha256 cellar: :any,                 arm64_big_sur:  "0f31b0ca051c5caa089350b30ffd07bed2c24ff2c64dcec6776e19d594b36ad7"
    sha256 cellar: :any,                 sonoma:         "1fb3b69447553ca6d5ab2c3a98a44573e0dd3b176a68310b4fc543c68d72f7af"
    sha256 cellar: :any,                 ventura:        "1be5f2c7ce8ee18a767065c0ed7b3783de17a36dae8eaf73f838537ece38fb71"
    sha256 cellar: :any,                 monterey:       "22747b60848d59c6989707efb0373305af7376de07a4e8958426ddff11ff6bc5"
    sha256 cellar: :any,                 big_sur:        "153a648ed0bdec6e1f0abbdbefff2815b793bf79c4967c803cf55a512228dcfa"
    sha256 cellar: :any,                 catalina:       "d84220ffc41768520239228b13a8466493682fa30a670163041caa0b06f449a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e094f664eda5e0dabb7269b9a6129d97028bf76e10a6f0d3966479fee9cc79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5c0a1ade41f7ff063620d37b071556cd71382e9728f160c24393809f89c0f80"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    # CMake Error in CMakeLists.txt: No cmake_minimum_required command is present.
    inreplace "src/CMakeLists.txt", /\A/, "cmake_minimum_required(VERSION 3.10)\n"

    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `LOGBASE'; CMakeFiles/arss.dir/arss.o:(.bss+0x18): first defined here
    # multiple definition of `pi'; CMakeFiles/arss.dir/arss.o:(.bss+0x20): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/arss"
  end

  test do
    system bin/"arss", "--version"
  end
end
