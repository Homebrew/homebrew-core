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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0321ec60acd8a30dd7eeea9b679637304318669b1ed43e1b6fbb93a3277f2903"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347ce1b20027c44a89574d58a960b3e1126a0e7b39c24e3ee855e67da6c94726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef9e7bf3fa26b211ffb1fa2592b6595eea314a8aa7dbe0858cc75d877004b28"
    sha256 cellar: :any_skip_relocation, ventura:        "782c7751fe18f69f7409be21fcf1c037d111d01b99141043dd43bd3fce30972a"
    sha256 cellar: :any_skip_relocation, monterey:       "677064f3ddf5de10e21b57cb755659c8a5269f533d7979650377567d265d32ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0db9c92b9bc916ecd88f7b67e4d5fee7378c0a85d576ba12f1e12362aec2456"
    sha256 cellar: :any_skip_relocation, catalina:       "c58b151b7c65f18cfc11daaae87fc532d9021a9b09de9287696dcab6d4b90b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13a8dfbb93b8ddf44dc033e892ed3846e1ac2760d56e0bb8b0ffb24aef465a75"
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
