class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.30.0.tar.gz"
  sha256 "8e829c5ea6c1c34f392ea1900df7191eb521ecd126a4495933c41f81482f65a6"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01b5f3b48c216451c5b0a76744866be0e00e7ecf2be3982cf80347c81ce00808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb05500d474f1bf6f9c501642be876321209cb7432a064268887b018508699be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ea5b8436e50f82526e989e852242dae9565f5a4ad3495397ac5f5c3287772e1"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1b8ec3a35ac25bab361641f860c07aa9d136a74cdbdcf036661140b4e9cebf"
    sha256 cellar: :any_skip_relocation, monterey:       "1f8aa17cd7445af1fe6795a94ddcb54be77371910f19713ee042541bfc0ca728"
    sha256 cellar: :any_skip_relocation, big_sur:        "0610b3bb04a1ee19e23fb4ed5a84dd8e19fcbef6ec66124992b7e3879a8fb7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1bb5f5807243fd03d39ef95ddc22eb11586a38c3acb36783bf9ab54982b1dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
