class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/v1.15_rel2.tar.gz"
  version "1.15"
  sha256 "c7ada78211517176ac5d38850337500d132813e2c0af3bf338e66cac71ee5153"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7982400af9801d4ed2d81455d90eef83b3ad47390af70f644d9fbbd664f860c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49c79e20a8cba9eec7772c3c16d91d9f4f6950f60f08e514017765ca35dd009"
    sha256 cellar: :any_skip_relocation, monterey:       "1dff0fd6ab85ae31905a9771048440b77fb8104be739a010dd2b9ef2bd47e65b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3564f412c01518c7fa8489cfff76e4c72f96972055741651383dcbc1f621d44"
    sha256 cellar: :any_skip_relocation, catalina:       "20c4d1f426658cdde46b4d535d91254796ac5f5ca51ae7c741630bb06ff9545c"
    sha256 cellar: :any_skip_relocation, mojave:         "fa893b4498d244cb26f6a35db9059dacc84ef0fc6c60558c51cd60faa6ca222e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a571eefca9a99ff9dc3faa67e12f1292cd207d57fb2dcfb90ea31144b8201c5"
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
