class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20220403.d4e7fcd.tar.gz"
  version "20220403"
  sha256 "8c7f325166b86055232cca9d745c6a18dcdcb6d30a0685e07ac0eab677912b05"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6cf8b434be0827f277b9043b15a59a6843bd5937da10af44d1087bdcec9e08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f60ce7c47f5c64db7a5e1e89dcac05ddeecada4d9dfdbf328f5d0cd45d15c49b"
    sha256 cellar: :any_skip_relocation, monterey:       "204b2e212223e5133f1657a83e14d2196c5005ab30da463fbab61a6225814dca"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5e855dbc1d178cf473944fbd8ec5259afdb848878877466707a001a9f0f861"
    sha256 cellar: :any_skip_relocation, catalina:       "3cb8c3a7dabcc937b7fd31f1105c8341ecd958d9c8828260eecaae3552f8bd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc48797c6da6992d4e02855e83776571057921f9077407c989b36769fe21535a"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
