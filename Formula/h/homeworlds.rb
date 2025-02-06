class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "323862cec62cc7a1f2129bb1bb68a82f64251a71c50ceb1630efda7464b33807"
    sha256 cellar: :any,                 arm64_sonoma:  "01ce88d66f29d1f27d2ba6281e0c9f0099c7c182c6060925227e5fed54b21299"
    sha256 cellar: :any,                 arm64_ventura: "4019f9ab84a91f717ea32f22c76ed28d7a9d09c41a1d9696dad5ea41d7ea1105"
    sha256 cellar: :any,                 sonoma:        "01083a3070b6876d2e87fad46003b66a81f2f2d369a7bfb5db09f0f686802238"
    sha256 cellar: :any,                 ventura:       "603a72bed37ea7e7b648a7ad5ae5cc0bc3ca794a413b90153842aec1deacc175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07434afe254326ce496c2d01fdae03030850cf825a7d6ba33f61f9d059799627"
  end

  depends_on "wxwidgets"

  def install
    system "make", "homeworlds-cli", "homeworlds-wx"
    bin.install "homeworlds-cli", "homeworlds-wx"
  end

  test do
    output = shell_output(bin/"homeworlds-cli", 1)
    assert_match "Error: Incorrect command-line arguments", output
  end
end
