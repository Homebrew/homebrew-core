class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "86845104668c461742586fa604c2aa0cb38689503e75aa20aebf4caf3372c4a6"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2587ed30c833b1381ddb611ac545ef0ed6b3584e7b014dee9a975086d3ce5d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a691e7210ff7e3d85f740b3cdac8f3e4c9c853a2ab83450171f02c1bb58e3200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c78ad9942aac7dcbd7860d54263163ccc503d2e1acffac5797f5ce28869fade"
    sha256 cellar: :any_skip_relocation, ventura:        "7c2eebb619393c3146ae64bcba7080dcf08f6ca9f69cdfc23ec4a9dbf8636857"
    sha256 cellar: :any_skip_relocation, monterey:       "056dc03b14867b35cf3038b280c2d82a502d917d3b67f1e2f74a8243c2baa6fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c81fe860c90bc2c085813ca6ee678ef60318e3ea12089ae96161c77eace5eee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814918a2fac31536d77fcd799382d082a5f8d314d7ef5550dbe2788c0710364e"
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
