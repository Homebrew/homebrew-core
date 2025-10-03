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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "482c49cc210fac2c0a124061fa36c9b9dd5217338698c14ce6cb2eb52fdbaf5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3295228dd92c0233d71546962d8ae9ab3ea7611324e810b0446f601f8d9e9e07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b9b3070f946ba91f4789020f92b61a92c0a07956f63e9e4fb6b5b51858172f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92708846e9acdc1e65588e3404f835f91ef55c272d2d28e37893b519a30c156"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d72352ffb6de0c6ce0a925ca48e8e3276a99b4c15e503360a46dfc19f4b12dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "132951513f0022d9a2f8e0b0f81a5d76668b292873df6d6c67b81c4cd304ac31"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f1bc038c9c6fbeff3e20e668d00f9f7786ce288939c53992ac62596a13fc7ba"
    sha256 cellar: :any_skip_relocation, ventura:        "121279d1be5fc110bd686a6c1648ffc7325065140086e57473d96b2a09c5b456"
    sha256 cellar: :any_skip_relocation, monterey:       "3ecaed3130b7884171aac431fffd4b6be19ad322cc990a4659a26407ffb799fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cef2881fd23f1e0b7c465080379f8564b00da6db94cf28f5da272ec19f565014"
    sha256 cellar: :any_skip_relocation, catalina:       "98fa360ee6e7ebc233784d62c599bc07bd92131159bdbc64d233ad99f883a99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7460fa4aa8b4de099df311c8058767d8c538e9950045134c3267f6fc47ec3790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b78fb761e9d2bccbc88b9893d6760f445eef59c2d122dace22541ef1e04791"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/mkvalidator/mkvalidator"
  end

  test do
    resource "tests" do
      url "https://github.com/dunn/garbage/raw/c0e682836e5237eef42a000e7d00dcd4b6dcebdb/test.mka"
      sha256 "6d7cc62177ec3f88c908614ad54b86dde469dbd2b348761f6512d6fc655ec90c"
    end

    resource("tests").stage do
      system bin/"mkvalidator", "test.mka"
    end
  end
end
