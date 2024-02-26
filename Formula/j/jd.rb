class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "40635f27543f91e656b902b94a2d6e9f4ed627b940484ad59b18fc7fe458f4a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44342ced934fc84a32d58485b71e78cdd61cb83a0f158c227341377524253040"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "885ef9f62bc779ace9aea2e3d79db0fc8ab3213509efc4c4cf601ee0ede3cab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d87b1adb4c6adb855b5bc12e4491704808cb40fb8509f7f25b49541d423beae"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a5d253451d6bccfe182f5ad50be25dae8d77f0544b970f26ea757a4c72fefff"
    sha256 cellar: :any_skip_relocation, ventura:        "706e6bdabb4da45aac30a7529b4e17c264218cf957e5c525832ecfd5c46712c4"
    sha256 cellar: :any_skip_relocation, monterey:       "2afec1e180625e0343ecf60db750c54c101887df84fa3499f5a60a708c7025cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82eaffe0e56b4db503c3d68f7ce55e20f11fbcc1fa985a3a8b8431c8c1e51c21"
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
