class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "d9af81b30f83d080472e91da3e07b42294904827ad5274d9aaf51d346072d2f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d09b8e44325873978a2f096693d5fcb1e1fedf5c67ba36f3ddc59e8de5c40bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af1339ad8610100b8aa111f445051464eaa24525714a0a5c92a3067fedd94e29"
    sha256 cellar: :any_skip_relocation, monterey:       "3984ea9dc69651689691c13d59130d6cf46d2e843924184e4a47afe0f1d20396"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ae970087d5e7f1dda0b8a1c7075f67a940dbcae21e57691a6ecdefe3613e47f"
    sha256 cellar: :any_skip_relocation, catalina:       "8702c7ca103ecb9ea09d8127f79fc226bcbe8e22bf99cc507c10b9f4fe5496be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71cb847e867ef385e8f9d3f5c4fd66cf6cb73d962db205bd729062ed90ac7d96"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
