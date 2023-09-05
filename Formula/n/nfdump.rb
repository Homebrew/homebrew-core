class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.7.3.tar.gz"
  sha256 "9ea7e1ded34a81839b73e66cb62c9bc11a8070210584f9a508798d7bd6058c89"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50eeb03bae9b62393985bd7879eb640422a75943df16e9f023bbb0eedbe0a8ba"
    sha256 cellar: :any,                 arm64_monterey: "fe3792a8237227e5d1b26a9fb0a175053c953270e082844a31b178bd08c1119d"
    sha256 cellar: :any,                 arm64_big_sur:  "a0f283180241934960029478fe9215ae5b0eb2160f8b1989e9ef9750024ec858"
    sha256 cellar: :any,                 ventura:        "33c9d0b402c2b4f30d8bae3206323dc9ff7f1100950c0e9867736bd38daddfa0"
    sha256 cellar: :any,                 monterey:       "cc5a415e262adc15e207645f11d265298c9a73a22c8d441b1ae11fdd9c9fe818"
    sha256 cellar: :any,                 big_sur:        "0db91bfdde00f9eaf26f2ab5a23f4623f808ddca50ffef180f7bdd4537187f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b970f64f2505ff3028cea23a1015664c490606fe8e9c52eb26284e7353aba299"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--enable-readpcap", "LEXLIB="
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
