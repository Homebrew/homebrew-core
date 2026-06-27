class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20260527.fdcd2b0.tar.gz"
  version "20260527"
  sha256 "5303c8010addf1b2dec5375c8cf32d70e1835545d639ee2183863e09d4e80aa3"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d5de28b578d9bf806a56bd01182467bd2978fd69e47b51f10735f28c2b89ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b7af1d0d8c081628109d55aa72560b68154b4d10f23dee791f152a237fdc565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e3d5b673fc202ac79d21019152ebe47e26c0558a33bcb2ce2a635d1124889dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf1fa9fa0911eea396f3aa1f2258ace34feefef8b968a3043ba4d427c4e6858"
    sha256 cellar: :any,                 arm64_linux:   "729b19d3141ebde1f08c3b98f8eefb68c8a9a9708208013d1f65dd2aeb5c0fbf"
    sha256 cellar: :any,                 x86_64_linux:  "98981aa30643c7837c6cd87a6569723dd357dcaea8ea5bd4feacb25ffaf763c3"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"ipbt"
  end
end
