class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.tuxfamily.org/"
  url "https://download.tuxfamily.org/baller/ballerburg-1.2.1.tar.gz"
  sha256 "3f4ad9465f01c256dd1b37cc62c9fd8cbca372599753dbb21726629f042a6e62"
  license "GPL-3.0"
  head "https://git.tuxfamily.org/baller/baller.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ballerburg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae944e9578696b3db8837f70d14a1552ba0ba9266d5fbe187a34a25859132411"
    sha256 cellar: :any,                 arm64_big_sur:  "c6e8f97813801312ab4c54442dc85dd8e2cf772c362e7aa9d6b3daa672cc8713"
    sha256 cellar: :any,                 monterey:       "74404aea5fb599ca60eeefb923c7cbb3c83be71feacc36cba240214be3cd8664"
    sha256 cellar: :any,                 big_sur:        "0dc9fbcf422de9697fdddfcccdf4b032eb8319c18be6ba21f538f2f3cfc68676"
    sha256 cellar: :any,                 catalina:       "cfdafcf254b4dd8521fc55db1e3a6d746fd3af97a3157df582c19900b66eb945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e7fbcafb82c5e59cfc89681819751e914898cd1db706341db6fde64207386b"
  end

  depends_on "cmake" => :build
  depends_on "sdl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
