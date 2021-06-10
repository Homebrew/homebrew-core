class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.4.tar.gz"
  sha256 "c2671595f1793b498cdf50b9dc03d632cc724891de7909f2ea78588fbffba289"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    sha256 cellar: :any, big_sur:     "78142363e9004adc7286f2393e1bfd663dc55d85225d84da75c285d3dfa021e4"
    sha256 cellar: :any, catalina:    "efae02b7bab638b75b39abf29163349119b993697210e3dfeca5456f610241ec"
    sha256 cellar: :any, mojave:      "523459616f8fdf7507c66c4c531e329e8bf37c08633e72401de47fdd010990a6"
    sha256 cellar: :any, high_sierra: "0f41e7e368a435f1680195d86b7eabbfd46f40a0905bd8dd8b52e199d92fc3f3"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
