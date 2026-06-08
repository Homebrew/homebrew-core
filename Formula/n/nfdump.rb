class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "d9b881f7e3ecde281c1116e8330ae612d0e5adcd0e952f401b2045c6446a1232"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5d6b64b0cbecaa2cc585e8f387dc9194d02fe6991cf310c35c3d6dd54df3bcd"
    sha256 cellar: :any,                 arm64_sequoia: "5ca8bd4545874a70900fd98e5696b129b46de6b0d54ea98c65c5777e5ec69d8a"
    sha256 cellar: :any,                 arm64_sonoma:  "53da326cac8cc89db21970ce35d800a0ff6ab6f2d8888b70d16573e7a9c4cab8"
    sha256 cellar: :any,                 sonoma:        "b08e1cfd6b72f2a75784bf3dd69688c6ab4614520631d62627267ae1ececf325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83ad503a74619c003a0ca0e045d94c2393aaf07c1aa6222dc6834249df04acb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbf3db1dbea03ecd41ccecc432f93b12bac05585f40590a99f27e2fbf20150f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libbsd"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
