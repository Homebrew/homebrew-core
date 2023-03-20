class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "5d508ea6374702f04f4b21f6dfb3d287922d3b7d5860dfc3fce2366128f371a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "481a29b3152fbc8c2da30ac1299fa07830a959a4bdb4a7a79c6f30af7ced6f33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966d5222ffa62120480ed90a74a95ab47061af05cd3c5593b5b286bd55c5b3d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e75b31f750400118dda20861f2505618ca216425cdeefcf5219f56879abee75"
    sha256 cellar: :any_skip_relocation, ventura:        "8a56461389699156686e7aab222b48c2ca5652e58a8057fd85b8a97d61bbe564"
    sha256 cellar: :any_skip_relocation, monterey:       "5cde138d8dfbdbd7dcde1e3911c11482f426220df1ef09104f97dbad09fb70a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7389b4174d90135479252409010ad2f5296c3eb8cf1e8b9569f514af20dae753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7d7f52c59e10e6b4d0d99d51c504bc8f444a51326066dd1df4fb4b8a1256fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
