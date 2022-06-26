class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.9.0.tar.bz2"
  sha256 "2f5cdcab0e09b65f9fef8949a55ef00ee3dd700e4b4050e245d442347d7cc3db"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d88364bba58d17c5a2dcee261628dcaa7f488c65e59ba2d94470bdedf7a4315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cbb79d68f3b6f25830b76a374782b1cee440c6112280393a718f0950a561ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "6406bf244beccc28185413a3409dbc788c494017f237231320bf42efa54ce4db"
    sha256 cellar: :any_skip_relocation, big_sur:        "c840bc41e467e5e5da4a58843280ea53238cbc0574a1954904423fccf6a23350"
    sha256 cellar: :any_skip_relocation, catalina:       "233250daa7e3c2b5dea11c5afd8fd2ac6985b054dac3e71ba62f6a7e02f302a8"
    sha256 cellar: :any_skip_relocation, mojave:         "ab570a0a6db26d6dbe08ab347ef3b8f881f77766ce2fbfffdf9a9c3b61a94f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784dfd7ae978f145af4b1a57535c915014f82f60f9a1876fd9e5edc69a947066"
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
