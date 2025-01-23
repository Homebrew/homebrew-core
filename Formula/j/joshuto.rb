class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  stable do
    url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.8.tar.gz"
    sha256 "877d841b2e26d26d0f0f2e6f1dab3ea2fdda38c345abcd25085a3f659c24e013"

    # rust 1.80 build patch
    patch do
      url "https://github.com/kamiyaa/joshuto/commit/1245124fcd264e25becfd75258840708d7b8b4bb.patch?full_index=1"
      sha256 "089a7b5ab92aafa6ed9472328c0ad4401db415cc1b08e102c0751430f0f61465"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05358a2a7b19b860ee8a0f96183f86587d0db37bb0d3caded154c7cf92c09f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce1ddf54bfdc995486062ed770d1c80f1343c6df4f15bd120fb05ea57633b383"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f514471db634eef5bc7be735708cb9a3d3adc731c0bd17536b9bdf659a2db118"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d5f791245b275fef1e0ea33481a5ead7ce2ee3ff8b3335d48ccc1ea767e552"
    sha256 cellar: :any_skip_relocation, ventura:       "e1bf0abd5d2379a4611cf2860282f8d456816c57c103ba59af215499e4a67a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5fd70baa48a4e36ac7c6be47c6c4517ddd39af97e88509cd3e0dad8f6efcdc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgetc.install Dir["config/*.toml"]

    generate_completions_from_executable(bin/"joshuto", "completions")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    fork { exec bin/"joshuto", "--path", testpath }

    assert_match "joshuto-#{version}", shell_output(bin/"joshuto --version")
  end
end
