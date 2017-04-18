class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.3.0.tar.gz"
  sha256 "2481bdc4966edaf65eef8bb97f102f089954641956b60b5e5e505f5d38ea48ae"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "916580406ef23c40923578539b1dea643c2a05577e0d210ddd2af4a4c6962297" => :sierra
    sha256 "72a80596dc070c76b919c6babf385d723399b8348fb610ddd13c8e7577c030ae" => :el_capitan
    sha256 "4d5ea927f341f399192979f32507c46c700f873ec54e2997b480b56f4173dbbb" => :yosemite
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
