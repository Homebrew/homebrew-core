class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.6.1.tar.gz"
  sha256 "84bb9349129ed14b7ab17361faac3535be5f21b46c9757c1fed96a0e1023dd65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0287b5cf9314c770c429fcb46ffcdcf96f626265fe56704e5083cc160855bd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a15264048b4b0010c8f38f5ea7bf29c39f0de2640d3d24e60436b7b1674897e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc3608e2ac9ea6a24d6ce598887d4e882e13ee553b48a623b2c2c02977677ac3"
    sha256 cellar: :any_skip_relocation, ventura:        "0b23650f2fb0ce355d330f89f953e7ffae56a2fcc82b846aa2b151a235a71f24"
    sha256 cellar: :any_skip_relocation, monterey:       "cefe4b5b22f42cfc6046201c18bfe4fbbd6236b79d735b9745d4b755901be3ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f23e89f68920eeb95612024e8eb9d67cdb70197f5a5ad46ed36320aa8ac7b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "739b083792e347e858e78225acd7f1eb7e2d7488cd8101507fa50e26af2550d5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
