class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.3.2.tar.gz"
  sha256 "3767e39099a29bda54f31b33dd41611ca051d7323b1c80fdc477c4c8b2a720a4"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b24edc58c03c75ac3c9c6653d99afefe93f0762f4391cd7fd57c25896101fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff559a6d8205633e4c0b5f48806bc9b5cd6fed5054010e6c6bd0609ba80c0ed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd6e61f232b271db681b8f0aa3d5ccce8360ad0c353be32dc4c1fb78ce719df4"
    sha256 cellar: :any_skip_relocation, monterey:       "7c86f9b24c52a1553a50aaa424844af68c56fb3ff04281d89a25fbd71daea377"
    sha256 cellar: :any_skip_relocation, big_sur:        "531353433aa2afa0fad0a254e9c2aa04ca5f3b9276deeb810a4f3f012d16248d"
    sha256 cellar: :any_skip_relocation, catalina:       "9884d5239751090b20bea865598b7558ad536e638c50ebc15008df2fadee5b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf38b0ae95afa921935531d912f187454510b544b6637c02927bfc897ce51069"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
