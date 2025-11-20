class Libgadu < Formula
  desc "Library for ICQ instant messenger protocol"
  homepage "https://libgadu.net/"
  url "https://github.com/wojtekka/libgadu/releases/download/1.12.2/libgadu-1.12.2.tar.gz"
  sha256 "28e70fb3d56ed01c01eb3a4c099cc84315d2255869ecf08e9af32c41d4cbbf5d"
  license "LGPL-2.1-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cfc0b8f8f9e11600773fd1edcf8db8e797aad7d436fe9f92db2f9a50e08346e6"
    sha256 cellar: :any,                 arm64_sequoia:  "f4f5668e14d2fb3565732fb50bb526d106a8a26d396b3d54eeff627658a159ab"
    sha256 cellar: :any,                 arm64_sonoma:   "c0a47f65b2950adc32a349c14f576ce66da2f34b2fc342c1f37b11dfb8ab28ed"
    sha256 cellar: :any,                 arm64_ventura:  "ea113337d33a26b40502ef72b239b0e7eba6a01290372cb70f857e21d4daf2f1"
    sha256 cellar: :any,                 arm64_monterey: "74b16aeaa51b6e018a7548cf7e9197836af9b6da578b86b44917813a23fdf380"
    sha256 cellar: :any,                 arm64_big_sur:  "e556444015bb575c2d7efc07815f72141da829fcc67262238f72257110226c99"
    sha256 cellar: :any,                 sonoma:         "2f18df590a9b25654a85628539fd4465d8bf8db62855f73d128b0711437c9b3b"
    sha256 cellar: :any,                 ventura:        "c1e8f89093019a8904f82e94cb054280ee125ee99965cae3dd48ede9f777f137"
    sha256 cellar: :any,                 monterey:       "229f1b486e46ceec14e6480aa9b3c727639a42caceb6cd556cb56cc2b8d7eabb"
    sha256 cellar: :any,                 big_sur:        "d9f8198b7a7640ec47933ebbb7d4cab50bc0f29fe20fa88126e6ecd6b116d62b"
    sha256 cellar: :any,                 catalina:       "afe9b94a62b55c700f57d853d077be96a901b450faa7ff9585a43397cacf838a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e39dd5e82e385a92ce8c507ef104f14c84ef65b617b707eaee76debc345c273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "879c676edffa46a33d49bb980f2759b9a4db1d8e505473593c1d0873266ea0dd"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-pthread"
    system "make", "install"
  end
end
