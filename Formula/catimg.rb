class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/2.6.0.tar.gz"
  sha256 "53d6cbb5844424a4e8422b54c873c301c5ad0f286249c73b2e1a790dda991a3b"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c969dbc14fe8778d997abe119365a9a5b72a5192a2a73724edf820f4cc3d73c6" => :mojave
    sha256 "afc3fe119461f26efece013456a43798b2898e4c903d80e37998222081e7699f" => :high_sierra
    sha256 "2a7088bcac247d0dde972240369c4e7708511072f95e4bf43e3a1e2daa8e4e30" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DMAN_OUTPUT_PATH=#{man1}", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
