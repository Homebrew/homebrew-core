class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.6.5/hamlib-4.6.5.tar.gz"
  sha256 "90d6f1dba59417c00f8f4545131c7efd31930cd0e178598980a8210425e3852e"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52361ca2f7c283d4ac611e48949e9a836ad4c2ebafeea173ca155fa069b79b64"
    sha256 cellar: :any,                 arm64_sequoia: "f5f911f2d2bbd62db0c4f035b2981effa2a0cb707cbe1c90921a876b0963e89c"
    sha256 cellar: :any,                 arm64_sonoma:  "aa6b8f1343b9e8198fdfa3f5e4f922b6bbf8fd2c241a0bc29c641032f5ce1497"
    sha256 cellar: :any,                 arm64_ventura: "12173d014b2ed5c2a3be84f7d1e4e12004c9e3b00fa8ee080c2203707e0ad870"
    sha256 cellar: :any,                 sonoma:        "78e174b60ceff2f87ea130e76cc6d3a847b3621c801df5cb8300ad914bf11b12"
    sha256 cellar: :any,                 ventura:       "395b325ce377fbbf27eb7ddf58860f106ce9c3220ef3c49a4af97ce0a1cdee36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a1a7ab9c3845fb861f3576d80c2ba903be90106e6fdee4369a31c17e1c0998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50132a1960ae0bd91563ba7f73820d5e5f2d58567e4790a33e957225643c582e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
