class Ddh < Formula
  desc "Fast duplicate file finder"
  homepage "https://github.com/darakian/ddh"
  url "https://github.com/darakian/ddh/archive/refs/tags/0.12.0.tar.gz"
  sha256 "f16dd4da04852670912c1b3fd65ce9b6ebd01ba2d0df97cb8c9bdf91ba453384"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bddfd92127ffb3ef31b00d86ec550206148c166d1c06482598377d994c4bc373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4623ac62b866bfe712e7a773913868d2c8d961e90817a7bf71d4ba215c331aa3"
    sha256 cellar: :any_skip_relocation, monterey:       "5e34e90440cbaedafa0d6a6d5f1c31ab39c237b97f2622cea06343aef091dcf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a297fb91f7a38ea49776e3c74815fe9163087e29aaeac6dd573e9aa8e727102"
    sha256 cellar: :any_skip_relocation, catalina:       "5ff60c70bc0f14279c88ca8d9169801c2ba9e6b9fd23034c36241c13acdcfcc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a74d6464ee92da9d5b8c5a979a8b86a53dd54f7677a4d7a1ca6e5ca9b8df96db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test/file1").write "brew test"
    (testpath/"test/file2").write "brew test"

    expected = <<~EOS
      2 Total files (with duplicates): 0 Megabytes
      1 Total files (without duplicates): 0 Megabytes
      0 Single instance files: 0 Megabytes
      1 Shared instance files: 0 Megabytes (2 instances)
      Standard results written to Results.txt
    EOS

    assert_equal expected, shell_output("#{bin}/ddh -d test")

    assert_match "Duplicates", (testpath/"Results.txt").read
  end
end
