class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.51.1.tar.gz"
  sha256 "90e12f89ec992c71c9288003de4b41914186b64f1cfa51667b9496afb99ae082"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da8a88883e259d33d56c0d59c8ad71a29ef87751e03a00ad9be48bce56f4808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6723330e3b3c7de2d2253c9b8fb98360931dd5339b80cccb266830e96708f13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71155a27fedee1b2e6d8986b3145ec966b624590f982517217d2e4c65c434171"
    sha256 cellar: :any_skip_relocation, ventura:        "c23195b52440106cb7988b73e3ba16479bc14dd5ceb65c6e127071358a0d51b7"
    sha256 cellar: :any_skip_relocation, monterey:       "eda3304d1b567d0a7b1fd0a84137d75fc256230f4eeb7504cadfaed0adaabd6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a5876e92f5bc7ded8578bd8208b2ccb8ce9ab6dc9de419f7177a3b6efd21b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4972a3086b346880fc38eea582438bbe0377ce417fcb1c1674fc019e24b21c78"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
