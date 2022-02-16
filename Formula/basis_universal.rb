class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.2.tar.gz"
  sha256 "ab253ef2cde8afc3f2ad9a30f6983f495e334bac6239364d2ec421d0d586a37a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7ac9098df6c21052a799525237d519d0a51eddc48c657559a25e4460224848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7d04b017f2970b278442d1c93876750236bec6cf97cdeaaecf9e5acff6cdd2d"
    sha256 cellar: :any_skip_relocation, monterey:       "e09f9f13045a76c990ae7412be39057d915ba663225478ec6342908038205657"
    sha256 cellar: :any_skip_relocation, big_sur:        "04dd92b15a1935d768c4ed1bf02005113e6ad7eeb488d6b9a4237659709191bf"
    sha256 cellar: :any_skip_relocation, catalina:       "a007613e46d3594a34188c1e540985d845f014ec50b8297d34312a635662c0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12dc500008fa872be4094cfa375e650395181f565baa3091e348618933d096a3"
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
