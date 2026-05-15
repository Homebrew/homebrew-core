class Mdq < Formula
  desc "Like jq but for Markdown"
  homepage "https://github.com/yshavit/mdq"
  url "https://github.com/yshavit/mdq/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "81d6ecb8602930483c234cc3a4242f8c66e82d93010114062b394d46f7c464ef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yshavit/mdq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44dbf65e532102fab1fe3696799e103e33914180cc4ff55f53c27581211dab8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedf5a7d73236bde6a4b2c844b89f7c684345d55f1772c52cc626e3f3903b713"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68e29e84b838d2cfc8ccac060bdf6ae0a39525938f9550e9469691209e3e66be"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e90583bd84c1b738f32ce66319f15f5f85d5750407fb28547736440bc86596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5a5192fb6b5fc71e3f182d67073708c550c02e4c7ac46938c835b58bf62de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a16dd3968228e3fa3edee20fb3e43b74c309ac8eb12174591d2ee527add7806"
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
