class Partio < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/wdas/partio"
  url "https://github.com/wdas/partio/archive/v1.14.6.tar.gz"
  sha256 "53a5754d6b2fc3e184953d985c233118ef0ab87169f34e3aec4a7e6d20cd9bd4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c5edd20c87a7b31af0632e12bb7c69ebe51e08530d33a292892cb5757b503b5e"
    sha256 cellar: :any_skip_relocation, catalina: "513c77edf0748cfdd80dd8806add9b0166e2fc947de7fc89dc0a86e68505aece"
    sha256 cellar: :any_skip_relocation, mojave:   "8450fd8658881dbf6b9459bfa272339c99ed0b54d7e165b8f0ee6b85a68b95eb"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "doc"
      system "make", "install"
    end
    pkgshare.install "src/data"
  end

  test do
    assert_match "Number of particles:  25", shell_output("#{bin}/partinfo #{pkgshare}/data/scatter.bgeo")
  end
end
