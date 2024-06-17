class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20240501.bc876ea.tar.gz"
  version "20240501"
  sha256 "9bd4ace9028d8932b28981d83be850b2f9ac9ffd27bdeaddd61defca4e2e2762"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a5962d337b9f02b55c07799962a4bab60e5e5e15f80eac3dcd8f8f3ca58b45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21d4ab887b377ae0412a97b2606451f68e56f399c41dec96638cbbcfa526f147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "628a3b94dd728ea0c02f1bf6fe42a10badea4ff86c8ba1271b2fd933b8da23d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e887f491af53ff7750ad41b618df73b7c10dab613ff8807cefb1c6d8d044b9b"
    sha256 cellar: :any_skip_relocation, ventura:        "dce5a5b85fc7ed4d107c7ebad14f7d6225d5226d5337cc22f1de1e5ac723b2be"
    sha256 cellar: :any_skip_relocation, monterey:       "63cd96623d8bc087247d9cf0ea601a36ad62a5b5c2422256878da8c490fcfed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9cb3727a0fbd659d98a5fd34a6d150e828888f8f8ceeb304735a4a790e1397a"
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
