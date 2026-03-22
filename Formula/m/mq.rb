class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.20.tar.gz"
  sha256 "ac4a759e0bb0149bd176e9800a4fb76bd61b6970de2b3baaf83cace7a49ce530"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be6f0d80da70dca86c65faf1edf26e7a39c51ce08727f8ea3135bbf3f9835f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f40dd85372aa9552cbd3a05f68386e248133b9938af6a301c2025ba0f6d1a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e230646c05281cf6f690731a78f67b4d252b00a420cd33ffece40ef948208cd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2064b5b6dbe38422f56d005a268df6e151884b5b59b20ecb9cbb1e4d6dcc7c77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f32f0eb9240b5c264d4601d8e23b922c6aeb9adc6950b3b2db4e9e94801961c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f11e9833efcd530579c3a900872e63b156104878e1db8582e698030c0be334e"
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
