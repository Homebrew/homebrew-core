class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "https://potassco.org/clasp/"
  url "https://github.com/potassco/clasp/archive/v3.3.2.tar.gz"
  sha256 "367f9f3f035308bd32d5177391a470d9805efc85a737c4f4d6d7b23ea241dfdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd9ad8525cfbb0692dd94cedbd76849edbc222fae644b27fe1e106679e39c64d" => :sierra
    sha256 "66882d87c5b4aead5af374d54438cbac8877c493e0aaf56798e8c629581d7186" => :el_capitan
    sha256 "a7770d88cfb59b6678f297ceaa8a38e305eb11a28df6a887205a36c90728c973" => :yosemite
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
