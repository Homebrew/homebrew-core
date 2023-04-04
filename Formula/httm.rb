class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.25.9.tar.gz"
  sha256 "3a20a58d3b4d133476f1b1f629ae792c3bf5a8a28274f89c5ed467583efa503f"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457b8df031cb0b7c057bdd176a642c78dbd530b1dbce2dac82c95e8c86e0429c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a96b6ac4f0161d507c81783255c550c593b344bfdd0defc6df19118266c2af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f4cce49423ea1c8d4c28b2ba10a131e18163069474c5473039f2ab8f48500d0"
    sha256 cellar: :any_skip_relocation, ventura:        "5b3e3743ad17479eabe474d219e747c2bb2f135b2883b0a7ad15060f52cdb2fd"
    sha256 cellar: :any_skip_relocation, monterey:       "dfa6bdaecd02944d101cda37ab2343da4179c056b40ec69097ffbfbf2a77e3e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8da7849b002bd1d5d7bff2896513bc6a9462e7a06c497dbcc1cf6e0bf95021f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c8fd60d15ce5fd5e2e2f45c6f7b15aad035c1c3a073a3a7a13b322c6f8836d"
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
