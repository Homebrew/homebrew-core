class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f4d141122ad91d1e7628e9cfee95ca183113e144872cce61f6d3d56449efa19b"
  license "MIT"
  head "https://github.com/josephburnett/jd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0402bdb1aeb99940b6d32eae2eaf516722725b69a002f39122c248c01b037b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0402bdb1aeb99940b6d32eae2eaf516722725b69a002f39122c248c01b037b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0402bdb1aeb99940b6d32eae2eaf516722725b69a002f39122c248c01b037b"
    sha256 cellar: :any_skip_relocation, sonoma:        "be1e7d510c4494671a669db0aa1e49229067565f3ffefa22a46d343a67845223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c95f3a9f3c3781181a3686b9108f02befd26448297b877b2a58f9567e772fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e711c1e129381b62820ac48347eb8e55d19049ce76c6d8062b21cb1e973a42"
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
      ^ {"file":"a.json"}
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}/jd a.json b.json", 1)
    assert_empty shell_output("#{bin}/jd b.json c.json")
  end
end
