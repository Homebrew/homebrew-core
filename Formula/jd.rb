class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.6.0.tar.gz"
  sha256 "33c996e962094477169ec247ab5bd9f23a303dd5df40d6d5da39710c77ba97aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162568ea67afe2f06aedb24f151aca19954751fc8269905771fadf19659aef6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1230b40bffc88513cdb699943da2ed3cbc4a921ccee373bc62bcc004538d92b"
    sha256 cellar: :any_skip_relocation, monterey:       "6abadd8c7432050e03389f1b447b3570c360188f334a0821171ad321b5b8d3df"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cc3053fa3d814aecd682f78f9f9d0f509a439773a0e9a2529888bac06ad4ea3"
    sha256 cellar: :any_skip_relocation, catalina:       "84df3f3bdcfefb7ec2dee8472f54947881f7cc39121b78b2d62c19d234201051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4345fa43d0bb2d624184c744cb7625a14d9e99403591e94364ddb80925a8bd6"
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
