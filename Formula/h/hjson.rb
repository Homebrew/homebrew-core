class Hjson < Formula
  desc "Convert JSON to HJSON and vice versa"
  homepage "https://hjson.github.io/"
  url "https://github.com/hjson/hjson-go/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "2881c114bcd194860155885e3c3586b6e41832818ea5cbf9c661a6a7990a79b6"
  license "MIT"
  head "https://github.com/hjson/hjson-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a33156f50c63285d3df45038349df02997e8f177138201d44d19b313a3a2ed7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a33156f50c63285d3df45038349df02997e8f177138201d44d19b313a3a2ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a33156f50c63285d3df45038349df02997e8f177138201d44d19b313a3a2ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4a33156f50c63285d3df45038349df02997e8f177138201d44d19b313a3a2ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4aa5610d49cd7983041ac406238fc68c6726424ad23f9e2b762a64f8d4ce18e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "51aa8911adf1968269810f0f25131e813490c97782536646ad3f76341481955d"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./hjson-cli"
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
