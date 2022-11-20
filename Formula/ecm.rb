class Ecm < Formula
  desc "Prepare CD image files so they compress better"
  homepage "https://web.archive.org/web/20140227165748/www.neillcorlett.com/ecm/"
  url "https://web.archive.org/web/20091021035854/www.neillcorlett.com/downloads/ecm100.zip"
  version "1.0"
  sha256 "1d0d19666f46d9a2fc7e534f52475e80a274e93bdd3c010a75fe833f8188b425"

  # The first-party web page was been missing since 2014, so we can't check for
  # new versions and the developer doesn't seem to be actively working on this.
  livecheck do
    skip "No available sources to check for versions"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187a0f53b52d50cd1dc9989bb704dd06ffea7a96bf9d84f7fe10e9b68d0b5042"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c6317457a68d9f3a17da094fcaa1f110243d7031e16674aea65dbb4e23adc8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868674e4445ccdd9ccee5c57a7acdee0fd1de28bdd1a9fa1405dbc3c265d9bfa"
    sha256 cellar: :any_skip_relocation, ventura:        "eae5c2429a8813cde8a6a6ca91e74fa814b91ba802834868fb4c5cd6401e6d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3497ba452016dc190809d4bd25635685accc86d8f2db3785a3a6fcfbf8fe57"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe66585b67b58f533f0657def18a8657b8f46c3971c80d44e49f1241c7342da"
    sha256 cellar: :any_skip_relocation, catalina:       "93a81fd556f0fa5cb39016f88a50aa7880b65d7f281cd94fbdaba36320d33f1d"
    sha256 cellar: :any_skip_relocation, mojave:         "0ee8841213cd082cb18043cbc1bb6d38563abc05f5477906649b68665e82539f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "985409c27f6eff735bda8566c07ee787fd2ed4c92ac72c303376076d14e08dd9"
    sha256 cellar: :any_skip_relocation, sierra:         "888612dee7486ca5413e2b1e0090a4e1bd5ea7f2fe5cc53fe02bb326ed4f3d4c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3ecb325a368ef42737e77003e9ecc13a8d402a34da3a25c039b36565fef0b55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41307b6ed8b2c02efc9269a74424428f099ab9802a26e28dad16d7282c46324"
  end

  def install
    system ENV.cc, "-o", "ecm", "ecm.c"
    system ENV.cc, "-o", "unecm", "unecm.c"
    bin.install "ecm", "unecm"
  end
end
