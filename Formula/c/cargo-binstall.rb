class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "76a1c0baddff69efe5829de16700450d40e5ad9032823a03855b99645047b6de"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d165f41ab6ba5687489b41188efc91289bbc1d2cd8fe3dd1c4ecc8072a26db36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de24d65ea27baaa18840aa0527a9c278eb9e91706cbcd8df0c6d4d7f15cfd7c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "943fec67540cd2391512ccdc4fd979e70eb91584ecf9fad86ef47002177be615"
    sha256 cellar: :any_skip_relocation, ventura:        "fdde982c5cef51902c3f3e604c48ada64ef49d11d679cb11c699d46a7261c823"
    sha256 cellar: :any_skip_relocation, monterey:       "3e61ea934d7c2268d07ac609319cb13b2f307b153305d92d9325ecac5232d617"
    sha256 cellar: :any_skip_relocation, big_sur:        "517ec727b8135ab2d25c04d838e886a1fd8a85729fda44ec1ff2ada6d0ecdd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a616ca4c950e2baf40c0149c7e100dc84b9405d6d2e11338f72db10363178ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
