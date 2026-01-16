class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "084aeab667883da93dea85ece23e517e9d35aa1cfbf2e86dfc360556f71d2f83"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcfc103ee3e77348d2e926b7e11c03367357c0cc54596c952112ad50cb0ec7ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcfc103ee3e77348d2e926b7e11c03367357c0cc54596c952112ad50cb0ec7ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcfc103ee3e77348d2e926b7e11c03367357c0cc54596c952112ad50cb0ec7ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9fbde83fd5d2b67c3c1512b0ec62cf7ff9565645d4e0cc6f8558eea4469322c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffda495360ef70d13304338d7ba4201eed61da7d6be7c67f045ff2fac5e0aefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20b38ccd3d2c9636afa560f2c29ef87e532c47ada4cfc4df468bf897217dd12"
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
