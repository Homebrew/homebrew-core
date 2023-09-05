class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.7.1.tar.gz"
  sha256 "3d0b693546891bab41ca5c3be859bc760631608c9add559aa561fb751cdd1c92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2b07ba96ff95b927175fcdf22386d458b43fd0fd318263d7dfcd851deaa920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5459ba7e6a8b80bc8874dde1d866fda9b99f291ac41e462ec0de9c1eee45d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23b8fd52d1d4d56c8e402127d7fd5ec9f7d3939ebf0be57c0360265bdab09ab"
    sha256 cellar: :any_skip_relocation, ventura:        "17ae4f04c0016a933f923aacc09696a7ec54ac8ea76e5f2e7ba28903d84b2738"
    sha256 cellar: :any_skip_relocation, monterey:       "9080e532d8e9c322d6322148d2c7a21bc8606fd9257683724d02f43f21cd4742"
    sha256 cellar: :any_skip_relocation, big_sur:        "f40bd8456140f8332ec1e13efef5a260f12e33908306a6b6429cea3446140408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112215528c11ec54910cdbd320d9c0ced6714d87f27a573fb86e40c26829b70b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    output = shell_output("#{bin}/jd a.json b.json", 1)
    assert_equal output, expected
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
