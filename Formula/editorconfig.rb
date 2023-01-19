class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.6.tar.gz"
  sha256 "36052a5371731d915b53d9c7a24a11c4032585ccacb392ec9d58656eef4c0edf"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b30ba34e0591e4f6f86c6ad0a9ba8fa7ad766ff7692f010254e242a10a1b0e1f"
    sha256 cellar: :any,                 arm64_monterey: "e1be5f7ae1a5d746932cde2791637c52c9457abf4decffa0c3339600e1f7b2f3"
    sha256 cellar: :any,                 arm64_big_sur:  "8de5a49262229377ff5f97f670c729626c7c2a688c14cb901e1d6342eee99f92"
    sha256 cellar: :any,                 ventura:        "4e788b50b9f6009cd6dd3efc52ea327f70c33a24c92e8b029294344d3072fc4e"
    sha256 cellar: :any,                 monterey:       "8460e9b0785718dc81aa4c895a9e7a5225648e0958ae076d3f93b1bc897232ec"
    sha256 cellar: :any,                 big_sur:        "35b906670a62d96a889967f904b9b157ca860f72993be36f4085081df24d23d1"
    sha256 cellar: :any,                 catalina:       "b6cac809fe16ed3e788d3bab017f128a6c960652104ed541791cca02b6e4bc16"
    sha256 cellar: :any,                 mojave:         "553e730194b67c667c214f992fd25bd44974d7c9f6812641be65c4347370c124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73e6b268380b80301a12b510fb0c05c4ff58dc880fac3ad629fcfe22430696d9"
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
