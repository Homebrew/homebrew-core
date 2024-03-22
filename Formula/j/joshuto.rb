class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "877d841b2e26d26d0f0f2e6f1dab3ea2fdda38c345abcd25085a3f659c24e013"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ff09fff80be79c63d0cdef49c7776de4f75bd14cf2f1153637e4a3cfc83338d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1c2b9988c7506ab5082f473a90aa4ce65f43d6bb394ad0ae30be6f20f0b7bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab14e95d334507009ac50b0c4751f77a3f7d0987121e88fa2e461241ddfde1c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4773df9312ced27808540f9afddc9ca0f401c8f091fc81687a002a3c4a69611"
    sha256 cellar: :any_skip_relocation, ventura:        "d26a93ec3c602fa8f44121ecd41327f9e4d9c0f580dee23d1e9cc281fc175369"
    sha256 cellar: :any_skip_relocation, monterey:       "cedbbe159248265c9670fe0750ea00b4e1c21ffba8f82cb40dc1c6ca5ae2e0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd0dfeed3e38d17efeb3486d53658c423ef0325bc0ceab6fbedcc2a5b1c8fa1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgetc.install Dir["config/*.toml"]
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    fork { exec bin/"joshuto", "--path", testpath }

    assert_match "joshuto-#{version}", shell_output(bin/"joshuto --version")
  end
end
