class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.0.2.tar.gz"
  sha256 "95cd064a6026c11f5c2ff3591ccdcdf28a972d4ff634de8be99543703a5b417f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75818e467b3f232c6e6b393042b306f73b7e051b7096280007ed1752920c9b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a65772e727f7598625a9af69e3fe1269ba342f9610b27b9b9ac2d896a2dc5bbe"
    sha256 cellar: :any_skip_relocation, monterey:       "96cc40bbd31b8570773ea4133359be3165aa2777d736c78f0a551d48b1e3ed24"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdc60de6368d3e1379d735373018739ebd33a6e2f8b9371a61a09c5fd14724e9"
    sha256 cellar: :any_skip_relocation, catalina:       "8a0090643116f6f330aa36244a406b92ba81640be68060a71d1cfe6d4fc933b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45647e20c4656dec54d3c731217fdb42d7b54368b4c4b004419ca69eb223ca3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
