class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.5.2.tar.gz"
  sha256 "ff6cf8fabe65a5786652ab2a3ef762d5dc6b5595a9516f81eb0916fdfe13bab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94ca2241cc7da52c94a7542a6799fd8aa5d7ff46cc291f079faa7ec27d4b5d9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "605658f79872fd7c531ac6ffd4edef7da85e3afc9a947e2b053d3adee21eb5b5"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e5e0ce5f066c80b14d499354d6926420160cba5e9846f02bd69cd7f98ad011"
    sha256 cellar: :any_skip_relocation, big_sur:        "5afecb8dbe7400ac8482a1274cd0a034c3fa82622a85d2463993ad87fb4098dc"
    sha256 cellar: :any_skip_relocation, catalina:       "7c0544c944ee9484d78cbf4db628f671c6340fac2a57f84b8c28f17e5ebfc9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48aa7ad74657a071b8815acd54212fb7814f6bacc9f13b543cc347f5742cce67"
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
