class Hfstospell < Formula
  desc "Helsinki Finite-State Technology ospell"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst-ospell/releases/download/v0.5.4/hfst-ospell-0.5.4.tar.bz2"
  sha256 "ab644c802f813a06a406656c3a873d31f6a999e13cafc9df68b03e76714eae0e"
  license "Apache-2.0"
  revision 4

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "512a7ec1987a6ea4ba00e0e97744fe569cf086f8599fc1116d3a286430e51b82"
    sha256 cellar: :any,                 arm64_sonoma:  "b9620e78ab2a3afaa6dbfeeb225da7e9f1e5da55a0bf82e8bff66bf51a1c6bdb"
    sha256 cellar: :any,                 arm64_ventura: "68701bdb5dbcfc7e2874ed38329b15851fac68b5ffd6a9b4cd52017d63490f20"
    sha256 cellar: :any,                 sonoma:        "fd2830d383ff448efa33c3061360e7f95226c985a50cb01780f2220de2e1d1f5"
    sha256 cellar: :any,                 ventura:       "1f4cc82befe7f5e77bb255468434d980c15baa8b9eca1fd7a67003dcbdb17e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b8d7e3e410a5e31d3ddbe7f7954191e7dd4fb367018b8e80182befa52e5081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87395934d55bf05dbd13fa44c20c36d417a883bfb1080ca2fdb5b03be5237e8d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "libarchive"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--without-libxmlpp", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"hfst-ospell", "--version"
  end
end
