class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://github.com/harehare/mq/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "1ce55f8ad0c2ae7f9de58a2a09357b111bc3dcbcccd47a9f7d45fe80219d14f9"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eeefb06e6764d1d3122cc53e95fde3c0adb9f7a2f96502e607ef26f5ea77191a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deda553adf632c4b290132ac0443045203d56bec320160ecefb0c44c5147e01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f977253fdd3e5e7850ee568213d7ea8639a78cf6fe45949185a235c5660d417"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47ce0a39e391d9e692c16419190b37d26cdb6ca74605439b2640a21ecaa97e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b94142a4157acd3eb2c48167a0f9247fbfc311ead0a3bb3fe6373feeb6972df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0453a2108414ecb45b96ea34b1401b246ec1aa29b38127832d3f9b9985071ae"
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
