class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-1.2.1.tar.bz2"
  sha256 "7843cf35db40f3a2caed3d0b11256e226ef16169244ca2dc1c89af86ac8a148a"
  license "GPL-2.0-only"

  livecheck do
    url "https://dl.exactcode.de/oss/exact-image/"
    regex(/href=.*?exact-image[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3408ea3e3e84443be2c9f8c30c93f1968a623030872acda7cc6b8a3523e4b99b"
    sha256 cellar: :any,                 arm64_sequoia: "1088bf426db191ce01896d0f6bee7d239125996016df7886c596b6c10c91bf93"
    sha256 cellar: :any,                 arm64_sonoma:  "0b541496b7eb11daff86b7c6c6cf91727636b2bf3b199e756c07693fd5b98a4e"
    sha256 cellar: :any,                 sonoma:        "161474f6a91e5c07983fda9445d7d2e35ca02c1eb027fee8ebbcf34ffeabd749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b45b0d415e3306f409c1668bc6a00d76270fb66e92d28f9cbafc5e2bd704b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9694f083c00dc18913396ea49410cd410b598035718cdd1512c883cfeace46e7"
  end

  depends_on "pkgconf" => :build
  depends_on "libagg"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11
    # Workaround to fix build on Linux
    inreplace "Makefile", /^CFLAGS := /, "\\0-fpermissive " if OS.linux?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"bardecode"
  end
end
