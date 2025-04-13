class Hjson < Formula
  desc "Convert JSON to HJSON and vice versa"
  homepage "https://hjson.github.io/"
  url "https://github.com/hjson/hjson-go/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "ba09dd33d655d99578f78722035e136449fcc6eaf1dc1b12eef1f0bb858749d4"
  license "MIT"
  head "https://github.com/hjson/hjson-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a524276874872d3ffbfee5f62065b5a6f6e23471ca54462b1c51d4871629fdd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a524276874872d3ffbfee5f62065b5a6f6e23471ca54462b1c51d4871629fdd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a524276874872d3ffbfee5f62065b5a6f6e23471ca54462b1c51d4871629fdd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "820698eab9d0e0387089b4ef8bae5241a467b5cadbddfc75637aab484af2029f"
    sha256 cellar: :any_skip_relocation, ventura:       "820698eab9d0e0387089b4ef8bae5241a467b5cadbddfc75637aab484af2029f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239a4f01ec7c8f255cce7823b7ef9361edbbe1ff036b469b7f0cac6c13dcb121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601b7b091f0d37b1d40e798903dc3fa4fe1a4dbf80caa7de60cce49ad5831707"
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
