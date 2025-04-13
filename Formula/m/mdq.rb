class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9b1021bf710a1028d534769f6cbf035b199a6fc8a24607f2dbe9f3b18a7146d1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63475dffbbbaf2ef82fc4cb55c4fcc06b9b4f4a1d27fcb5ec518e2c28a08d3f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fda2a3f3e56e95f02c044c9bae6ca389d7153347dfc3983f81c63da6ac17f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e966c294c12f91f845f682c4db5bd01e20f791a9251860a16b4722071de9dc3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb770d6e239bdf7d7225310cfb365c08ca0b226d1e8555bfbc0e11d4b7ff6c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "60e96d3c81f8e9dd663a88008b8ca83207b73201b7b681a176d52eb89cf04db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b05ef4dfe526b9a4b00c12a67d7707b99e0b9b8a53e5acdb042f988d4c4dd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd5110a167b5c5948bc387aa57467a7ada85aa30b02ab9c4796515259a6d63e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdq --version")

    test_file = testpath/"test.md"
    test_file.write <<~MARKDOWN
      # Sample Markdown

      ## Section 1

      - Item 1
      - Item 2

      ## Section 2

      - Item A
    MARKDOWN

    assert_equal <<~MARKDOWN, pipe_output("#{bin}/mdq '# Section 2'", test_file.read)
      ## Section 2

      - Item A
    MARKDOWN
  end
end
