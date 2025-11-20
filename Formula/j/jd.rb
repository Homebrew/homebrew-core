class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "5c7c749f58655a29345d7c0345b803d554629ecbad439096a6fb28eeeff276c0"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04b3942cc2ea6a3129250512e1f06d9354ef9d2acc420a185e230d6eba1357db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c8688b9faa2ed36501f6cd8b07a424844c1addd0d5e9a5a800aac3b2acce32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c8688b9faa2ed36501f6cd8b07a424844c1addd0d5e9a5a800aac3b2acce32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65c8688b9faa2ed36501f6cd8b07a424844c1addd0d5e9a5a800aac3b2acce32"
    sha256 cellar: :any_skip_relocation, sonoma:        "3528b572d310d68bbbb04d7ee487142e34e2a4402cc279b45c9fe89458b02624"
    sha256 cellar: :any_skip_relocation, ventura:       "3528b572d310d68bbbb04d7ee487142e34e2a4402cc279b45c9fe89458b02624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f07f301c762898c1ae7c0ef3056a528a286ab3327324a95f021866134c34e82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105ce145b5b39abed50c84e01d71f75a0cdfc23cb6d67c627b81ff2d4a8ab177"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./v2/jd/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jd --version")

    (testpath/"a.json").write('{"foo":"bar"}')
    (testpath/"b.json").write('{"foo":"baz"}')
    (testpath/"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
