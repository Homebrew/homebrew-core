class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "92f1b183510874a73327bfb70cb2c0fed2fc1f2d08191f0736dc4863d6766110"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e8fc3eccec5d7cdd882b9b457051fe4126e27a633d42c5f71921889c8d0086f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00a6b8ffb60f702efa00a994ebc0524702950a2625910a62cc440d7b49c86a22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00a6b8ffb60f702efa00a994ebc0524702950a2625910a62cc440d7b49c86a22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a6b8ffb60f702efa00a994ebc0524702950a2625910a62cc440d7b49c86a22"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8c2f957c610c1cd6a61d16db61993fcddfdf99af05bc66ad3bcbd9f1ea49600"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c2f957c610c1cd6a61d16db61993fcddfdf99af05bc66ad3bcbd9f1ea49600"
    sha256 cellar: :any_skip_relocation, monterey:       "c8c2f957c610c1cd6a61d16db61993fcddfdf99af05bc66ad3bcbd9f1ea49600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb4a069f48c9659771846717bfd6539bc67ab48d9874f57e06e826e20631ca73"
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
