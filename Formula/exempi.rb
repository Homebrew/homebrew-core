class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.2.tar.bz2"
  sha256 "52f54314aefd45945d47a6ecf4bd21f362e6467fa5d0538b0d45a06bc6eaaed5"

  livecheck do
    url "https://libopenraw.freedesktop.org/exempi/"
    regex(/href=.*?exempi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2e51519592229e63435e6c09cd13b49dd3bf23c45a86e516de86a4b371f87e3"
    sha256 cellar: :any,                 arm64_big_sur:  "9993c63e20e0f25bec9217f10830945e93554caeb9ed96530b31386205f3b963"
    sha256 cellar: :any,                 monterey:       "a74e4c553bde5ea70befdb50e6b69048708be588b0103aa571645aa0ff313dff"
    sha256 cellar: :any,                 big_sur:        "3dca3e311a819ad927266feecc2a0fa06a6baf196290655b5531ec02ea97dddd"
    sha256 cellar: :any,                 catalina:       "3ef58fd5cbd177ac785cfab9b58f813ce24320a507243d9d7b6c940fd463564f"
    sha256 cellar: :any,                 mojave:         "189bb3c57e78845c33678353cb877ad7cdedd665087c0a4525397f32088abc39"
    sha256 cellar: :any,                 high_sierra:    "0843f9bc589fd3c9ed0f5dfd724ba60eea4832410a0b6ff831bdb22c6563eafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7dad218c3c0e3e3df9efc69e1a84cafd8a992c31157e610f0a382403599a439"
  end

  depends_on "boost"

  uses_from_macos "expat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
