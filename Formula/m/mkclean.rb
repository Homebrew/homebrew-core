class Mkclean < Formula
  desc "Optimizes Matroska and WebM files"
  homepage "https://www.matroska.org/downloads/mkclean.html"
  url "https://downloads.sourceforge.net/project/matroska/mkclean/mkclean-0.9.0.tar.bz2"
  sha256 "2f5cdcab0e09b65f9fef8949a55ef00ee3dd700e4b4050e245d442347d7cc3db"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bdff12bc960c01d63267c10c8b50d82711924792a21d0e92db9a96a951801c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b4d263e75e4ccfdc7eeb90529899374a43f38bafda669dd33c906e533f1e7738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d518850ce61f5e54380d36c14e6192ec43b52cc83fec9802a08e557d98a02b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33ee8ae207d85761440d0bfb65995068d7de526dda7f41c7828f4853eb499bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d88364bba58d17c5a2dcee261628dcaa7f488c65e59ba2d94470bdedf7a4315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cbb79d68f3b6f25830b76a374782b1cee440c6112280393a718f0950a561ecc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3115df87b40715857fe4c36e533b64064b5c6be389da5781cb056aa85452ec3c"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d048659cefd8fbf91df37f8afe2a5ddbfa1563eadf0669edc4b8e287853b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "6406bf244beccc28185413a3409dbc788c494017f237231320bf42efa54ce4db"
    sha256 cellar: :any_skip_relocation, big_sur:        "c840bc41e467e5e5da4a58843280ea53238cbc0574a1954904423fccf6a23350"
    sha256 cellar: :any_skip_relocation, catalina:       "233250daa7e3c2b5dea11c5afd8fd2ac6985b054dac3e71ba62f6a7e02f302a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "76406007335cf3bd4fde0daa9516bc34a2ace73fcd132ebdabb43513496b9f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784dfd7ae978f145af4b1a57535c915014f82f60f9a1876fd9e5edc69a947066"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/mkclean/mkclean"
  end

  test do
    output = shell_output("#{bin}/mkclean --version 2>&1", 255)
    assert_match version.to_s, output

    output = shell_output("#{bin}/mkclean --keep-cues brew 2>&1", 254)
    assert_match "Could not open file \"brew\" for reading", output
  end
end
