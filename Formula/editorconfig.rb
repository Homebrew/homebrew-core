class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/v0.12.2.tar.gz"
  sha256 "8a63ae63d3a2f2a202acbd94a6cbe3fa4450c2658e33e922683af33c48a9115d"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "35354362ec018a97bf33a912114c4720774c8875a8637465e0058728ecaff631" => :mojave
    sha256 "af22a9ade368239770c4e31b492755e432d4d588ae5b537fd05b05434fdf9624" => :high_sierra
    sha256 "fa30d3abbe6bc2e740050aa7f762de370edeff44b34b2676e77607ab34cc72a0" => :sierra
    sha256 "51227b53ae32e062299baf504cabf4ebd9291c07c1a28b620d26493f3019817d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
