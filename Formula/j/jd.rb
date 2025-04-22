class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "85abf994c1f11aa0c2d13db03b2f02cb458e987ceaaccf4200b10193dd2895af"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "849464c157d6dc35010b3fb9532f619db68ea4394c45992311bbdb7d6f592764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849464c157d6dc35010b3fb9532f619db68ea4394c45992311bbdb7d6f592764"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "849464c157d6dc35010b3fb9532f619db68ea4394c45992311bbdb7d6f592764"
    sha256 cellar: :any_skip_relocation, sonoma:        "74758b3059a267701f7cd9fe7ac20d32e38471756a80befd51010bae913dfb90"
    sha256 cellar: :any_skip_relocation, ventura:       "74758b3059a267701f7cd9fe7ac20d32e38471756a80befd51010bae913dfb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e97787a3acac2daecccd56c77f6b5fc1f8f09cdbd4dc5846d7e71d56f7bd33d7"
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
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
