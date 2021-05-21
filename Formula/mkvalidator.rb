class Mkvalidator < Formula
  desc "Tool to verify Matroska and WebM files for spec conformance"
  homepage "https://www.matroska.org/downloads/mkvalidator.html"
  url "https://downloads.sourceforge.net/project/matroska/mkvalidator/mkvalidator-0.6.0.tar.bz2"
  sha256 "f9eaa2138fade7103e6df999425291d2947c5355294239874041471e3aa243f0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/mkvalidator[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "73efff490a07afdbccd396bcb5f0411d686757b5ede5d3c1340d76fd3b8d2a1f"
    sha256 cellar: :any_skip_relocation, catalina:    "ee45e5e5abe82cd60c970947d680a93f6987ee879b0f504ebff40c150b0a58dd"
    sha256 cellar: :any_skip_relocation, mojave:      "d8ed0ae48b3922549518802148f3687a9bcab9f072624d619e077368a874e71b"
    sha256 cellar: :any_skip_relocation, high_sierra: "5f0c85894cd7d4a7c5cdce1e26c5cc7c15ac7baa6c32a63e3474632f7727d8af"
    sha256 cellar: :any_skip_relocation, sierra:      "5f0c85894cd7d4a7c5cdce1e26c5cc7c15ac7baa6c32a63e3474632f7727d8af"
    sha256 cellar: :any_skip_relocation, el_capitan:  "6c253cdf3c824b6e37af7cca51bf05a930785286bc83ec367e10500d9645519c"
  end

  depends_on "cmake" => :build

  resource "tests" do
    url "https://github.com/dunn/garbage/raw/c0e682836e5237eef42a000e7d00dcd4b6dcebdb/test.mka"
    sha256 "6d7cc62177ec3f88c908614ad54b86dde469dbd2b348761f6512d6fc655ec90c"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "-C", "mkvalidator"
    bin.install "mkvalidator/mkvalidator"
  end

  test do
    resource("tests").stage do
      system bin/"mkvalidator", "test.mka"
    end
  end
end
