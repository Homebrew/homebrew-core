class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.9.0.tar.bz2"
  sha256 "2f5cdcab0e09b65f9fef8949a55ef00ee3dd700e4b4050e245d442347d7cc3db"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e1566860e6b09b48b227415b7f683aa1774d218c96b9c5bdf754614c809c4100" => :big_sur
    sha256 "8bbf507533210f38e1ec8e8f18238194b9d67cc54c9d037b25670f6d48fbac6b" => :catalina
    sha256 "645c0b42475bb4d09c2c27219e80ffc3fed4c34b72c5f6bb0e8534cba1101ea2" => :mojave
    sha256 "eb519c8f3fb9b2773529d5e7a9751cec7e2a7a67a76af92cab0e6b48449dc6de" => :high_sierra
    sha256 "73e502b5331d28da40fc3b94763f6ea30a141e48329bede7eddf3e396991671b" => :sierra
    sha256 "a5db5b2309de19ea395efaafcf828c253e38133464faca623545a221f2b0ba52" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "-C", "mkclean"
    bin.install "mkclean/mkclean"
  end

  test do
    output = shell_output("#{bin}/mkclean --version 2>&1", 255)
    assert_match version.to_s, output

    output = shell_output("#{bin}/mkclean --keep-cues brew 2>&1", 254)
    assert_match "Could not open file \"brew\" for reading", output
  end
end
