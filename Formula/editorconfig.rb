class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.5.tar.gz"
  sha256 "b2b212e52e7ea6245e21eaf818ee458ba1c16117811a41e4998f3f2a1df298d2"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c6d2a8fe0234a4cc7919238c801c2a57c729f50e8d70ee6078d412cff6ef5d08"
    sha256 cellar: :any, big_sur:       "78142363e9004adc7286f2393e1bfd663dc55d85225d84da75c285d3dfa021e4"
    sha256 cellar: :any, catalina:      "efae02b7bab638b75b39abf29163349119b993697210e3dfeca5456f610241ec"
    sha256 cellar: :any, mojave:        "523459616f8fdf7507c66c4c531e329e8bf37c08633e72401de47fdd010990a6"
    sha256 cellar: :any, high_sierra:   "0f41e7e368a435f1680195d86b7eabbfd46f40a0905bd8dd8b52e199d92fc3f3"
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
