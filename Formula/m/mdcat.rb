class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/BIRSAx2/mdcat"
  url "https://github.com/BIRSAx2/mdcat/archive/refs/tags/mdcat-2.10.1.tar.gz"
  sha256 "e3cc1cdd24e793b7bc7a1322467f935a48662ffd8a2aa5a65bdc0c6df5c9b970"
  license "MPL-2.0"
  head "https://github.com/BIRSAx2/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567dd251be0081a305d71f1b662e3ce973e3b4eb52430266cb4157cd1beafb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8347fc6ae3268cd6cc9d9531149fe96f27601338b1b0b1adf278706ba0d5a85f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a238e0f1c24b9afa85624b1b1671913c29bfce9a49885eaf3f2dd1b480513266"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1f935ea302e0a17b9da5c0fc9bea8000ec19d73ce70b1009d3908e366ab9ec2"
    sha256 cellar: :any,                 arm64_linux:   "e479dd54c7166074cac9d7ebaa3b76a2d2437a3cf3432c4a3a1f4bd0539271c9"
    sha256 cellar: :any,                 x86_64_linux:  "87bee9c6f2bbdef4d3627193e79e2f82b37cc5681a313f2be0778484ab9e700f"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # https://github.com/BIRSAx2/mdcat?tab=readme-ov-file#packaging
    generate_completions_from_executable(bin/"mdcat", "--completions")
    system "asciidoctor", "-b", "manpage", "-a", "reproducible", "-o", "mdcat.1", "mdcat.1.adoc"
    man1.install Utils::Gzip.compress("mdcat.1")
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      _lorem_ **ipsum** dolor **sit** _amet_
    MARKDOWN
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
