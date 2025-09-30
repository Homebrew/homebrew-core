class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "b7290079f7bad945c5118769948478e8cc366c2bbae198af6a3e584244045ead"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cf9c66df2fb9ea12258a22cf535c90cf0bbb4911998415cca88836a4004577f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5686a1f7a704889783de56052ab51b2d903ace30ebfba90a6d5a41bdb2e12fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd6e7b7380c8bed5b0419a07094791a12fefe7dca2241257a719d6bb399ac37"
    sha256 cellar: :any_skip_relocation, sonoma:        "37823a3a9fc252f22412c31d66e5f15a627312b05a9184b4a9c372b980d3bf39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634eb555d3065ab49bd1a2965199c7467f0ea674cdb55c917439cfbc1e74aa1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de9e6255edec1119d5d4aa89dafc5a6cbff8aadc5ec84b43bd58a0977e24c6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
