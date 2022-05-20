class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.6/ansilove-4.1.6.tar.gz"
  sha256 "acc3d6431cdb53e275e5ddfc71de5f27df2f2c5ecc46dc8bb62be9e6f15a1cd0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d132cbebe0b7721ff99b005736e156fda26d3c00f6b30237082e94b998235e90"
    sha256 cellar: :any,                 arm64_big_sur:  "50bf2d107f2f652d5001663abb0093c81b2097df35debfc9a6bffabb18b66058"
    sha256 cellar: :any,                 monterey:       "55dc300fa60aa6c07ceca616d721d37fd8bb80f1a0089a629193c78c5ee3cbb7"
    sha256 cellar: :any,                 big_sur:        "def7370b111a3bab2d6fcfc5642ddef272b3384d7a38d129b5a06252d271bcfa"
    sha256 cellar: :any,                 catalina:       "23311433311e4ac5df9d720d0f54903188b98cf08dc243be5e4c5984876d4e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6e591444c9d1288a71cc45904bb9bd1de75d878b44c3898cdeacdfae0834e7"
  end

  depends_on "cmake" => :build
  depends_on "gd"

  resource "libansilove" do
    url "https://github.com/ansilove/libansilove/releases/download/1.2.9/libansilove-1.2.9.tar.gz"
    sha256 "88057f7753bf316f9a09ed15721b9f867ad9f5654c0b49af794d8d98b9020a66"
  end

  def install
    resource("libansilove").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end
