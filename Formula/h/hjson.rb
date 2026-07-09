class Hjson < Formula
  desc "Convert JSON to HJSON and vice versa"
  homepage "https://hjson.github.io/"
  url "https://github.com/hjson/hjson-go/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "5ee5ab2b191f4464a9ac98c3047441d94bd9d5fdeb77f651f9d90f1dacd54f74"
  license "MIT"
  head "https://github.com/hjson/hjson-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc9750fd1bca7e7cc3eaa64f7601818a33d663e2b65d7245b62fec5056ee6f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc9750fd1bca7e7cc3eaa64f7601818a33d663e2b65d7245b62fec5056ee6f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9750fd1bca7e7cc3eaa64f7601818a33d663e2b65d7245b62fec5056ee6f6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "acd2ba791152d363026d562d6f35165950fc5fe18e85ed9187a55b6f2ffe10a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efafdf6aee5a9a12591cddb5087bd48434f36e93a13be831d70cd98e3a5ba260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebe393b4febcf6fa2248cd911e5d547028e5b9c75877058d03a159dd0cebc2d"
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
