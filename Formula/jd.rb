class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.7.1.tar.gz"
  sha256 "3d0b693546891bab41ca5c3be859bc760631608c9add559aa561fb751cdd1c92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8255ec6e06bc4d044f6181924ddf842e217c798d5f52a0c4690bacb6f64ad960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3ee6b9cb4222a1623e03ff3a036ae4047e1f8f976c9060d06ce683c13262c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eecc45d5b53ae750cf709d9e53d5cf95f36f8196cbfc420cee06cb285a7e4b7d"
    sha256 cellar: :any_skip_relocation, ventura:        "c1317eebb4d15892ecd020bd411f4544fa7ef65627fbc42aa40c1a68e865f645"
    sha256 cellar: :any_skip_relocation, monterey:       "59793f1d9eee68ad5597b45aad611a80626d95f37e8a5e3eb0c1b5ee0187a8f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07f8e0c35e55b8c199ab9650d59723797efffbefc587e7bf3a0e372f4b9baa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51979891e39cd617e79d33642fc905b13ece762fe2cd5e898bff66cd06d86e91"
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
