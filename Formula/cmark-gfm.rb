class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.3.tar.gz"
  version "0.29.0.gfm.3"
  sha256 "56fba15e63676c756566743dcd43c61c6a77cc1d17ad8be88a56452276ba4d4c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "215ca612a34a62533cffd87ca075b07e4b7000462ce0597863806941a35e7dba"
    sha256 cellar: :any,                 arm64_big_sur:  "65fb4a92ad77038e9ed86c326bf70cd3da114c6b81263f5cd3d540cdb584f717"
    sha256 cellar: :any,                 monterey:       "d50121029ed09bf22c80fdcac22cfb7ea71191785bb0f90cc570d93411b92053"
    sha256 cellar: :any,                 big_sur:        "5a957847eff309fb0119460a301f851a282774c9d8601a2f7ddb484fbb9e340a"
    sha256 cellar: :any,                 catalina:       "632243f006c84b2ef42110844f6ba7344b76172f9bfdc35d031c025376c93db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7008a12bc36b961dc37bf3d574592c82930ff843a7701f81cca40628a20c1c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
