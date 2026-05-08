class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.28.tar.gz"
  sha256 "11ab88170c73e006102da48d9cd9dd283e75185ed4964c43bd12d19eeec28760"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3bb6473ecd762dcfe674b41fb7c8faa30c2e4de94291bdfc5e32fcf1e8c794f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272ad8100cebc5f4cd2c2179e05da416ba68db29ee15d4cf0f777ed2864695e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375c67c74556f98b2ffe36659c35c0728265bd9d3e8771cd714e218c224954c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c54dc41784f076e2a64ac1c93cac45372f08926d686236e5bf70d33dbfb6856a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf48bf60d4aeb582418fd9c7c68e3d4d90a9af15c792450a78fd77d5438da167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf253c6898e912619eb91a54561e45bb6be62ec5f9729e722d94d3540f87395"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
