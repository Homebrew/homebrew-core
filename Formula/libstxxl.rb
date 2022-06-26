class Libstxxl < Formula
  desc "C++ implementation of STL for extra large data sets"
  homepage "https://stxxl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha256 "92789d60cd6eca5c37536235eefae06ad3714781ab5e7eec7794b1c10ace67ac"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e487af039d6286b34dc4aeac3c0eaba10668054b33a368e54f9cb8647834ed55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8454123ffed231405d684ed18c2ef1a0ab1bd118d74614748a5b5df23d8bb5fe"
    sha256 cellar: :any_skip_relocation, monterey:       "5916828893681e83b360fbd3638499592b65f39a546b64156aac85bf52a90550"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f8dceb4e0a1716a2c193daf4b5eeb4ae3e8e96224bdc78ae8f74c2a3059152"
    sha256 cellar: :any_skip_relocation, catalina:       "b4d5ef6b70735617973eb1f45214b11e3e6baec242bc6aa5ba9ed4da1834f6ad"
    sha256 cellar: :any_skip_relocation, mojave:         "9b179722c61ea55b352c9196ae38d6915a3625096117088d43f854bee4eb6a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8651bc71eeb58d5fc34d8b934576ceec8d7735575c595e50e8dd8e4d2dc84ae9"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
