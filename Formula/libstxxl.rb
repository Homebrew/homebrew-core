class Libstxxl < Formula
  desc "C++ implementation of STL for extra large data sets"
  homepage "https://stxxl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha256 "92789d60cd6eca5c37536235eefae06ad3714781ab5e7eec7794b1c10ace67ac"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3f8dceb4e0a1716a2c193daf4b5eeb4ae3e8e96224bdc78ae8f74c2a3059152" => :big_sur
    sha256 "8454123ffed231405d684ed18c2ef1a0ab1bd118d74614748a5b5df23d8bb5fe" => :arm64_big_sur
    sha256 "b4d5ef6b70735617973eb1f45214b11e3e6baec242bc6aa5ba9ed4da1834f6ad" => :catalina
    sha256 "9b179722c61ea55b352c9196ae38d6915a3625096117088d43f854bee4eb6a39" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
