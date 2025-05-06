class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/refs/tags/0.17.5.tar.gz"
  sha256 "f55350f7778c4ccd38311ed36f39287ff74bb63eb230f6d448e35e7f934c489c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fc482e70ccaeccba4657dd863bb31d30be2875e8352ba4be2b72e8f57f8ff68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219b7e7aa07d76183fd4e3512226b64ce5c75fa9ce163cb570bea085c2712b40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a00bd6097b4202256a07c898fae04dce40aa51b62b173694b62d431073760fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7052e202732f908080c493de6b0daba9e48ccdd7d19a3846afe951c63009fe0"
    sha256 cellar: :any_skip_relocation, ventura:       "4bee455c6966630660ac785f84b894b1a036e6abff5e3642ecc2a194662bae62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50239877c00a44b5b9bddf51944fdc4cfec571ea2e41244e519443b2e9138255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5228b1e9dada4c9b4721064ba858ed361778fa7ff36cb2b682c906737ec31b92"
  end

  depends_on xcode: ["12.0", :build]

  uses_from_macos "swift" => :build

  conflicts_with "mintoolkit", because: "both install `mint` binaries"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/#{name}"
  end

  test do
    # Test by showing the help scree
    system bin/"mint", "help"
    # Test showing list of installed tools
    system bin/"mint", "list"
  end
end
