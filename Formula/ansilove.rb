class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.7/ansilove-4.1.7.tar.gz"
  sha256 "6f8e2f6248775d6f8aca23b197b372ca7f8df8ade589ca4d5fc9a813a5d32655"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68af4a3eaedf130505f266c9b4f78b97aaff261d1a069b1a2bb78d923a433004"
    sha256 cellar: :any,                 arm64_monterey: "44c6977c4141f47172e2874c1d211c3e51c280ec66af678ada1a77c99947e1a5"
    sha256 cellar: :any,                 arm64_big_sur:  "3d6490fe5f97b1e5fc9010cbb20288f40122fc1d03e3a26e4dcb6763643c7b86"
    sha256 cellar: :any,                 ventura:        "f0ebe089e435b4be65ab45e037bd86b0f49c902ae11e266527b63a54faaed5f5"
    sha256 cellar: :any,                 monterey:       "1b570a5760065890e889d474b7a3b96fcced5e88b7e77cb1bb72e90abe37afc9"
    sha256 cellar: :any,                 big_sur:        "a290f8dce50bb7356da325d3eca325f49549a79c9f59093806a4165ad2c89741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b52975d669e7e0db90b48e14540beb8f41a7603927330ec9338cc613fdfff148"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  def install
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
