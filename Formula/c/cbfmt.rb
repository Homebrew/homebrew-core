class Cbfmt < Formula
  desc "Format codeblocks inside markdown and org documents"
  homepage "https://github.com/lukas-reineke/cbfmt"
  url "https://github.com/lukas-reineke/cbfmt/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "42973e9b1e95f4f3d7e72ef17a41333dab1e04d3d91c7930aabfc08f72c14126"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a548edda1fc0d3a727eee4b0a49e3a88d38ec88b2ac5c9108d5ccc449223954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19d661d5df158a765e9d9103ffa76a63d069106a79da5e96425cb3f7860cc054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9450f078799be6460d360bddede919f33f4afcf8480f951edadc5d93ad2b9887"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd536fee66c066b0027da4659d5b7e6ec316a98545fbc84b00a6833d919d2e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "f40cb83e59d37c6826a8f99871de12db752fcc8f9830bc4857347ed733cd0b02"
    sha256 cellar: :any_skip_relocation, ventura:       "d08bb1b815be4f880c84e38c49cf1bf7c14ba83670350fc7c77305bebc97faa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8b95c554dbf6e4179ba91f4eb93afc13949376af400131b280f0a792ba8bd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef8994fb32668715f46c8efcd584938cb5cdce740e65f98f9047698ee4e284f"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_config = testpath/".cbfmt.toml"
    test_config.write <<~TOML
      [languages]
      rust = ["rustfmt"]
    TOML

    test_file = testpath/"test.md"
    (testpath/"test.md").write <<~MARKDOWN
      ```rust
      fn main() {
              println!("Hello, world!");
      }
      ```
    MARKDOWN

    system bin/"cbfmt", "--config", test_config, "--write", test_file

    assert_equal <<~MARKDOWN, test_file.read
      ```rust
      fn main() {
          println!("Hello, world!");
      }
      ```
    MARKDOWN

    system bin/"cbfmt", "--config", test_config, "--check", test_file

    assert_match version.to_s, shell_output("#{bin}/cbfmt --version")
  end
end
