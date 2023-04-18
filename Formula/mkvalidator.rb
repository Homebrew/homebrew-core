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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92708846e9acdc1e65588e3404f835f91ef55c272d2d28e37893b519a30c156"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d72352ffb6de0c6ce0a925ca48e8e3276a99b4c15e503360a46dfc19f4b12dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "132951513f0022d9a2f8e0b0f81a5d76668b292873df6d6c67b81c4cd304ac31"
    sha256 cellar: :any_skip_relocation, ventura:        "121279d1be5fc110bd686a6c1648ffc7325065140086e57473d96b2a09c5b456"
    sha256 cellar: :any_skip_relocation, monterey:       "3ecaed3130b7884171aac431fffd4b6be19ad322cc990a4659a26407ffb799fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cef2881fd23f1e0b7c465080379f8564b00da6db94cf28f5da272ec19f565014"
    sha256 cellar: :any_skip_relocation, catalina:       "98fa360ee6e7ebc233784d62c599bc07bd92131159bdbc64d233ad99f883a99e"
    sha256 cellar: :any_skip_relocation, mojave:         "4e2d50be71341f0a47591587ce3cc428da8493af87ea2bcdcca64c86cacd44f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b78fb761e9d2bccbc88b9893d6760f445eef59c2d122dace22541ef1e04791"
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
