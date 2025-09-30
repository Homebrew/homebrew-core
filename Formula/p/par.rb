class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par-1.53.0.tar.gz"
  sha256 "c809c620eb82b589553ac54b9898c8da55196d262339d13c046f2be44ac47804"
  # par.doc includes a custom license and alternatively allows usage under MIT license
  license any_of: [:cannot_represent, "MIT"]

  livecheck do
    url :homepage
    regex(/href=.*?Par[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0978d3a9780b797f148de2ec8b9c904ddca7dc7ed60b51d3d98a902f82a25ec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e9ddecfb12a39ebdfba8f7b76364ad415565f182ab871210af61218645e5e438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39ef4ab70ff5a020f370b7cc1d8c1c70c70e1ed252ac542a1eeda1140a2d8d0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bc0eb239a205ede7064bb04ce4430af97633910eb2daea94ea414e8c72f6d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1fb39385e25724a3f37b3376bfa2a977a9b38fd951fbc92459e4d932f770f42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051cff1396509692262c0b1da0e923a2d00e00b2ab7d3bcfdd877c8acb76169f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b21d6b36ab41d6586f4db99966ed207b05be23453f63c513cb649700658650c5"
    sha256 cellar: :any_skip_relocation, ventura:        "903d95c6efcc78e84ab33fbff492e320f0d02f451d4886b8d82d86d3e361b9cd"
    sha256 cellar: :any_skip_relocation, monterey:       "ea8a083d2e64d4f28515313b3d47ea7d63f6cc9b1b6cb60ddc88d7fd643e6265"
    sha256 cellar: :any_skip_relocation, big_sur:        "9af002ed591438fc64cf745df797fdd4c6138a847c6ffe650a8371ef6a2243fa"
    sha256 cellar: :any_skip_relocation, catalina:       "457e5ff8ba94268a745fc954f84cbbaab7ac7d3a239ca602107a85a2e5d146a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "01aa6981e7f7fed828872aa316d7598667d1393db76ddfcd6a89f49fcd0db75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236b24853fb3dab435d98266fd26a45f1d55653e8c032165b278e47c63c1789f"
  end

  conflicts_with "rancid", because: "both install `par` binaries"

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install Utils::Gzip.compress("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
