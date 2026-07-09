class MermanCli < Formula
  desc "Mermaid.js, but headless, in Rust"
  homepage "https://frankorz.com/merman/"
  url "https://github.com/Latias94/merman/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e1d787154be74bca8262cc9c83ee3cb3f7e0c13dd4b8eb65c41cb2e42d3b5092"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4daa688ffac31a161ffb0891f4c275f24f6dd7a48734c892b8b616099e968137"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f8bac9b238a6ef3e26d96700ea09ad4b14de1d9babd64b7bd3bbb323187321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afb0c31502c2b5c8ae821e704023e46681a92e806b465a1ed8914b0962e0961"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1bc9b5695e1605c38c5cae9210c82c1c0572a2b324aa872f76a047042aac20f"
    sha256 cellar: :any,                 arm64_linux:   "0e33aca699eb2f964c12aee57ad882653c766e1f8c1191c4b888ae6c77e188e8"
    sha256 cellar: :any,                 x86_64_linux:  "e5fd23a4d0746f01733134feea28a166b00fa97fceb0840aaeb776997f3e7a38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/merman-cli")
  end

  test do
    mermaid = <<~MMD
      flowchart TD
        A[Start] --> B{Decision}
        B -->|Yes| C[Do thing]
        B -->|No| D[Do other thing]
    MMD
    testdata = testpath/"sample.mmd"
    testdata.write(mermaid)
    assert_match "svg", shell_output("#{bin}/merman-cli render --format svg #{testdata}")
  end
end
