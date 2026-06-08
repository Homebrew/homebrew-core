class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c25dfdaec4eacaf47a601df84dde9d8f2016979b55e21130541255997002d320"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61deb8d73ce6f26ebcf7b1cfb769d6a73f2f1e465ddce85df069d1aac72d65f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "246dca2e21a75201b4e59f36219b1ce3a6dd82644c0cc94a32fbb5aa8764bf76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c0156e9ec52d99e19b6f399d4d049814bfcfc6bd0e9480c27edb07bbf60335"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a520e9fad4956698170cd3df5742318e212ec1c335266d2289f3df8c50a8294"
    sha256 cellar: :any,                 arm64_linux:   "717c24ba20dfd3a74871c120c1c88ec217359bbb3fdbdc0cc2c328bfcf2a143e"
    sha256 cellar: :any,                 x86_64_linux:  "990504b249a0517def7c48251b2d305f5175aacdaf77350df7ef7854e1d42314"
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
