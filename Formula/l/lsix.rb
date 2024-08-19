class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/refs/tags/1.9.1.tar.gz"
  sha256 "310e25389da13c19a0793adcea87f7bc9aa8acc92d9534407c8fbd5227a0e05d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, ventura:        "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, monterey:       "24d1e4ecae9bc35d3c0c9c027c9aa8dd08b85e77494e2dece0fda02274e2a4a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bde10359a7cad3e60dbd77bbb0e89eeefbc7f914de6ac27d3e038681c90523"
  end

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
