class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "https://potassco.org/clasp/"
  url "https://github.com/potassco/clasp/archive/v3.3.2.tar.gz"
  sha256 "367f9f3f035308bd32d5177391a470d9805efc85a737c4f4d6d7b23ea241dfdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "02cafaad412b7b4bc1c78bbd81f153345eb1eaf22050d55c2daba069a73ffa90" => :sierra
    sha256 "09acf6c42509c7cc80311c181685ebb39c319a80668ab3e7a452586a72961f7b" => :el_capitan
    sha256 "fb6c23036a3735c43cabbe38c324cd16cf07ed4c7463396d3c559bec6c4038be" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clasp --version")
  end
end
