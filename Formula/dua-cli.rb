class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "d9af81b30f83d080472e91da3e07b42294904827ad5274d9aaf51d346072d2f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c3ccb007af499535139d42913e692d7dadcd7390d15bd559e78d66b907ae1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6f31eb5d9589025ea8d8df8c4f97486cb2bb291c877ed2fccc4ca47e8054413"
    sha256 cellar: :any_skip_relocation, monterey:       "3c3e5cad55e362125540e61f040a8de9bc5f087c827af5155ce8ce17679cb034"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1e8151a904b5bc7e214a9d8c1313b68f09aecbe616f3a40da21f446aa5d18e"
    sha256 cellar: :any_skip_relocation, catalina:       "69ffc4ce475857b5564b7e63786b0ea067416d1078fcffe4a62b71e21344d147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "705b9b3a57d3ef584ca72865e9f831f59d079822e7b7de8025d2d8884ad888c0"
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
