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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb13fbe0d40a539753b2eff12cc997b0e8356e4a3870a6a7f7d58fc6ee14fffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5654ff693e79e548559c05fe5068242ddb204bc9b96304e6554c85be3e7384e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "515e47a07f94b1d95048ef41aaa02772879da4bde695d396fb919b41464dc88f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499051587a419c940c465feadcc24821b13f905f1b5283fdd6c90bd78226b794"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d4f280f210af9a9a3e5e58d1d8d5aa4ac65b8c0548beb95802e190c793238a7"
    sha256 cellar: :any_skip_relocation, ventura:        "222081d6fe474676f362cd7f00af82863f4e2ce02df6072ca2b426d5b337a01c"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f517aae52e613b3ccabc8c187f2049be74686720c1e5a1e130fe2f7e119bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d898caaab5ad36b353c3c00189939b9ff459696ba4e8ee0aacb281398f0d278d"
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
