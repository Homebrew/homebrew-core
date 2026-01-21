class Hjson < Formula
  desc "Convert JSON to HJSON and vice versa"
  homepage "https://hjson.github.io/"
  url "https://github.com/hjson/hjson-go/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "bd73ffdee391a51137544ca3fc0550a6d1e839d20088fe27bc20b2a79f7910b4"
  license "MIT"
  head "https://github.com/hjson/hjson-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27ebd73de9932c6cc82e9c1f1de2fbda9bb399f428a86a37b3480d179d48875c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b3481c44007e1c2bbe12d642ec95d55ecf79525580ce026ef1c26e9ad16fc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56b3481c44007e1c2bbe12d642ec95d55ecf79525580ce026ef1c26e9ad16fc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56b3481c44007e1c2bbe12d642ec95d55ecf79525580ce026ef1c26e9ad16fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcfc6613edc2126cad95c59980dc47d8efd368ad8ebfe19ba8fc644e45ef34cd"
    sha256 cellar: :any_skip_relocation, ventura:       "bcfc6613edc2126cad95c59980dc47d8efd368ad8ebfe19ba8fc644e45ef34cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54c62c7a294556247b593ef0ccbdeb41e83086d141990ac6e9e00b5abe6d1bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9daafea6f326b56f2922c76fc086e29ef65ac0ab49b8e7cfe660e9aa678c3ad9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./hjson-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hjson -v")

    (testpath/"test.hjson").write <<~HJSON
      {
        # comment
        // a comment too
        /*
        * multiline comments
        */
        rate: 1000
        key: value
        text: look ma, no quotes!
        commas:
        {
          one: 1
          two: 2
        }
        trailing:
        {
          one: 1
          two: 2
        }
        haiku:
          '''
          JSON I love you.
          But you strangle my expression.
          This is so much better.
          '''
        favNumbers:
        [
          1
          2
          3
          6
          42
        ]
      }
    HJSON

    (testpath/"expected.json").write <<~JSON
      {
        commas:
        {
          one: 1
          two: 2
        }
        favNumbers:
        [
          1
          2
          3
          6
          42
        ]
        haiku:
          '''
          JSON I love you.
          But you strangle my expression.
          This is so much better.
          '''
        key: value
        rate: 1000
        text: look ma, no quotes!
        trailing:
        {
          one: 1
          two: 2
        }
      }
    JSON

    assert_equal (testpath/"expected.json").read, shell_output("#{bin}/hjson #{testpath}/test.hjson")
  end
end
