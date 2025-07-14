class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "78c4a7d3aef8b9db3a96bf5e8cfce4de6140b54e199f95bb0aa12e3faf945e6d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d62733d4ff5786040dabb855faf2bdfd3afc18dc71e2e5e8eba6a95ea34cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7f9c992511e132f00af206e1260b67bb6620bbec88895d04e82b55af431651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97cec42ba436163973a4114d8e02887b685677e54f24ce521fb4929b2d01c6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d45788370c0ef381358a5121db6d0b8ac226c556e617da582850f43d4604e51"
    sha256 cellar: :any_skip_relocation, ventura:       "1c5bcc3686cc5e5326fc03b6b19c14c222ad5caadc798c0bfaf77b54bc4d237f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bcd6ba524cc957fd3b1d8f333df22712848a4fb716f73185b1ddf3f99115b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb272362a34a995b2f341b55c5800e0e60c228145e2ff8f0fddacf1e5016d12a"
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
