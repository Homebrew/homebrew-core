class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3540stable.tar.gz"
  version "3.54.0"
  sha256 "6ccb72bd08a44ce28b75fb4a9f74fd34f7a1f4f57a0ba6158b876cf04c0cb34a"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89677eecabd4822a9094a24c85cfaf2550047d07ee9ea1cb1cf1dddbd3234e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89677eecabd4822a9094a24c85cfaf2550047d07ee9ea1cb1cf1dddbd3234e91"
    sha256 cellar: :any_skip_relocation, monterey:       "d896adf5d00079e071d7060e290002ba5ff7a9c2ff0b5cadd74243f658b0ae7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee0e19927393ee65e2772366dea8dc1f33102de7bd7699b4637f0f9a8bad74a"
    sha256 cellar: :any_skip_relocation, catalina:       "b68c8a7357cf8358b474e0608771c9b1c1dc39df746f171f7906dbe694fd39d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09204e2d99e90b5b7e623dfb6df14156f533d9032e144c18b08180f6a43d624a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
