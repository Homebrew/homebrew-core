class Hjson < Formula
  desc "Convert JSON to HJSON and vice versa"
  homepage "https://hjson.github.io/"
  url "https://github.com/hjson/hjson-go/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "800b8f511f503b75bf794db2b2709bc15e8ea9e461eecdb2408472fb363189c2"
  license "MIT"
  head "https://github.com/hjson/hjson-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cda07080ae5d7599763349a9864986a4565f6a54477bdb649914608cea306de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cda07080ae5d7599763349a9864986a4565f6a54477bdb649914608cea306de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cda07080ae5d7599763349a9864986a4565f6a54477bdb649914608cea306de"
    sha256 cellar: :any_skip_relocation, sonoma:        "f62a181ee3b8a43c76b3128671799342acf407183533b2468e712df55f3dd43e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b224f4ae64d1b4a840e9212c529ac9f25899124707230ffc386d7808e4d75b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404aea04f3385d33a93e21cf5cd9297a704a03c0ff55d80dd1947325cd18fa5c"
  end

  depends_on "go" => :build

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
