class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.4.tar.gz"
  sha256 "c2671595f1793b498cdf50b9dc03d632cc724891de7909f2ea78588fbffba289"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "efae02b7bab638b75b39abf29163349119b993697210e3dfeca5456f610241ec" => :catalina
    sha256 "523459616f8fdf7507c66c4c531e329e8bf37c08633e72401de47fdd010990a6" => :mojave
    sha256 "0f41e7e368a435f1680195d86b7eabbfd46f40a0905bd8dd8b52e199d92fc3f3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
