class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.5.1.tar.gz"
  sha256 "6cc716026d366b4a3b235cf7142a29a0234459a4c845c01c6e94a13e02efc7d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5520a7f389bfb3eab351a7c07c08fa85bf160cc724e0db7359821b224e1b248f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3c2b304ffd8f5d828d173336ed9ff9eb3aa081a2b588e9f25f1bc9d4dd47ef9"
    sha256 cellar: :any_skip_relocation, monterey:       "88ef25cfc75d8528dfc6341a97a93cbfd237fcbcc8569ecbd6a0a3076dcd0390"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad7cf06f15b2825d615ebdc0ea1216dd224cf471d78ee3e1681642aed1ad3ba"
    sha256 cellar: :any_skip_relocation, catalina:       "262d32a1bd623b82784c6c3565052ee18678249a92dff6f997bae233a266ad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e799d1299d4b508d7b1d68d7c36cf1c0ba55cfc9239611e2ae467b45b1ecef"
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
