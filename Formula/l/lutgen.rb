class Lutgen < Formula
  desc "Blazingly fast interpolated LUT generator and applicator for color palettes"
  homepage "https://ozwaldorf.github.io/lutgen-rs/"
  url "https://github.com/ozwaldorf/lutgen-rs/archive/refs/tags/lutgen-v1.1.1.tar.gz"
  sha256 "86f65213c8ada58eee5b2e4113db5c6eeebf537356c2c62cd2bf5c3f1c8c7255"
  license "MIT"
  head "https://github.com/ozwaldorf/lutgen-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:lutgen[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f56fd5db55c6549dc2164e0584fdb2e8c6279550828dd8d5719033c844ef91c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf13ed6a2e07e210b2c7d087c19023424bf19fcf437c7d29ecc553d2f2af7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f0d1bae9fc167f24ee84969589406d3dd26d44710d24027f37ced125bed721"
    sha256 cellar: :any_skip_relocation, sonoma:        "906c04b93b136ec9a868fa46be95a6be40f212b395ac510d6a101fb7c8db0b79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dc053f36b84fa73aa71dd5bd738830189b48c68cd6a2ffd32e7b11872db63ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb666e2a3b097dc2a287913123f21befd1d5179851b68c84fadf28d4fc970ae0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lutgen --version")

    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"lutgen", "apply", "--palette", "gruvbox-dark", "-o", "result.png", "test.png"
    assert_path_exists testpath/"result.png"
  end
end
