class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https://github.com/RazrFalcon/cargo-bloat"
  url "https://github.com/RazrFalcon/cargo-bloat/archive/v0.10.1.tar.gz"
  sha256 "e8acd89ffcd555934672b0a10ba3b64072eaabf9d4ebe6be1bb6d4d7c0f9f73c"
  license "MIT"
  head "https://github.com/RazrFalcon/cargo-bloat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a64550c32194289c5391b52f0ccd0bd3a14d90ebfde45e049a47544488fe051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "689d61a6c4820ba08f71d4015c144d7d920d0cf86d253910bdeec3ba0db485cb"
    sha256 cellar: :any_skip_relocation, monterey:       "adbfeaac8141b8e96a8bb7ec59f7efbe253499149e521d4b165ee18a17815834"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a5085420d616ddf0d1a5450d7af511ddda7b82c356c1c55281f7950072031e"
    sha256 cellar: :any_skip_relocation, catalina:       "b68f52e68c24c3d0a451685c7f031d98e8d01850d2855e6ad1a72d5066502d21"
    sha256 cellar: :any_skip_relocation, mojave:         "03b2f370cc1a2fe4fd4f0b5db4009271a40a4294c2ea2b458220adfaedea5b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6055560a17d1843e15f8163e8388b3d1912a6ac34ca4623af8482bbdd912d8"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("#{bin}/cargo-bloat --release -n 10 2>&1", 1)
      assert_match "Error: can be run only via `cargo bloat`", output
      output = shell_output("cargo bloat --release -n 10 2>&1")
      assert_match "Analyzing target/release/hello_world", output
    end
  end
end
