class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.tar.gz"
  sha256 "2d4d8f1be7c2f177409a22f467109e4695cd41a672e0cd228e4019fd2cefc4a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593a6447170ce543fdd79e57374937e820fddab05b746a3c7344cad23156e101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93af0b17489acb28c692ef8634312e428412d4e4a8dbc3cd02d5db1df8591069"
    sha256 cellar: :any_skip_relocation, monterey:       "bd680f0d63293311b1b2bb839a8ff62254e0a6211ff4d8c9b415c0a810ac2c96"
    sha256 cellar: :any_skip_relocation, big_sur:        "8661008511d38f47a2a0765a45d482db70339578f930332d5aa47a647808f3de"
    sha256 cellar: :any_skip_relocation, catalina:       "15dbfe6e9a2c91ae7e34583addd2461e692f05c7219449e49be5898a01e16f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b421053f9844cc7fe2465b6edf0a340d9cab4237da35857cd9b119f81198ffc7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.basis", :exist?
  end
end
