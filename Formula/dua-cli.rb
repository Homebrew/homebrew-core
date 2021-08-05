class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "d4687f547cdd41bc1fe5976b6c6db7ae856bd9106d8fd8bf2d6b8c601cd82393"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1c355c8a2fc44384be3e936ec7a26e0329624b2bfccbde33a2fe85d7dd9f0f8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d712304297aa473fb0115e5662e5a612b07ef834910d9825d57d98d50eef0dd9"
    sha256 cellar: :any_skip_relocation, catalina:      "848fb09dd279f7847e74fc6448d2a519c6ee5fc5ee1bb1c5cca4e340dd7062f4"
    sha256 cellar: :any_skip_relocation, mojave:        "9c536710ed182219341050e1190c272155f0f9f6529c5a51d23864dadd377fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f687d5f44af7cf515f7db15544a56dfd285beb032349f1fa91ec94cedefd3c"
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
