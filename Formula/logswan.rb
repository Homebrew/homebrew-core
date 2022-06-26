class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.12.tar.gz"
  sha256 "8e954fcf5319b83f184b1a91d0af12c58bb90ab0f322f42ea6ad36fb05d57894"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98911904f9d24c6c556309550c9f589c1914bebce6aa470659e6781a3e74dea8"
    sha256 cellar: :any,                 arm64_big_sur:  "d8ce0bf6a0a4e1d115eb7f3c97917ff1dedc92feacfd2ac71e9868cf8b40ba80"
    sha256 cellar: :any,                 monterey:       "58b8f23d0a6b84b27dff099f653fdf0554b3fcb8b11a61cd6151a2c42b0b2554"
    sha256 cellar: :any,                 big_sur:        "505be9b725722f0ea783d0bc1176dd5c69694e850b318c5959be952feab9fc5f"
    sha256 cellar: :any,                 catalina:       "feb1433b085a21e6cbcd0ebd4405804933557a1b3cfcff29382c8a546269b8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1a973d756a90c3ffaa279b7339bf622cf28fdab6524671ae8937752086241b"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
