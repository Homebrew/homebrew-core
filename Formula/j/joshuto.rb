class Joshuto < Formula
  desc "Ranger-like terminal file manager written in Rust"
  homepage "https://github.com/kamiyaa/joshuto"
  url "https://github.com/kamiyaa/joshuto/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "85a230183f7478dee7c29229d78313ee07b759e596e19292acf024d2e5735efa"
  license "LGPL-3.0-or-later"
  head "https://github.com/kamiyaa/joshuto.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "997e069c04b3cc971c0a8ff11dd971e7e014d307f727465c48084472eabb83e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ad585ca047082e14eee51b99f3b49d398d72aa3fae3832cf14f791c08e3f3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de1edc19750a3dd9a77b12e416c56649ef001f3e97ecd67cac558a5861cf9eec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "313a6046629a46ad1233481dbb69184c6d1e6fe39637c938253a92baf21b4ad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fdf01d597c30f45454a3bde8c1868449de4e70ce162bd9649149c145462f3b9"
    sha256 cellar: :any_skip_relocation, ventura:       "9118c587822568b2063f55dbfb550f3c76a8ec6b38f4688c99d2964571a71148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33cc8898574c29eac9f32aad0da3c49c248f5be87fa38c0bd3f21b4ed0662fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56029dfb47864947aee35b14b6cd4197570fb2337a7ddd1b3f8e7a8cee99997e"
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

    assert_match "joshuto-#{version}", shell_output("#{bin}/joshuto --version")
  end
end
