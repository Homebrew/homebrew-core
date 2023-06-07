class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/ofalk/libdnet"
  url "https://github.com/ofalk/libdnet/archive/libdnet-1.16.4.tar.gz"
  sha256 "7df1f0a3db9cf03b48cf50ab273fd6a20c1be99eb9344b9663fe3fd9ed9dab65"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/^libdnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b4e6240f02055231150af7fff3fc0cd6ef978a5dd3e781bad9fe8c659a8ad43"
    sha256 cellar: :any,                 arm64_monterey: "1e64aebcc8dfdd50b1e14caef6ea9949b74146c59dbf771b1c5a14cc57ce8d8a"
    sha256 cellar: :any,                 arm64_big_sur:  "6d4fea190da54068b6a233e215bbad8ce34ad63be02ad25d3438fa1579e5e4bf"
    sha256 cellar: :any,                 ventura:        "ae71f5ddf8b8be40d02780276f2518747ed7f9587dae74d5ffdf4489d5cafc45"
    sha256 cellar: :any,                 monterey:       "08ebc0f4899e74aef420bce8d4c6aab333a4920957763cbcfd20100a6759a6cd"
    sha256 cellar: :any,                 big_sur:        "0d67a4d1892a14efca8a1b6205de86939d2b3cb900633c2419c0a3d13a90cf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e916f0d7b6cc35892197e9c7ed48e4f7c87a70c23147f6f7c1f1dd848d8ceca7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--mandir=#{man}", "--disable-check"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
