class Jd < Formula
  desc "JSON diff and patch"
  homepage "https://github.com/josephburnett/jd"
  url "https://github.com/josephburnett/jd/archive/v1.6.1.tar.gz"
  sha256 "3e81a8dadb125628430a31e3ea67b8b3053c346d684b74784c6bf0451cc2def0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1fa14a9e1b7021871903842379366dd5d8e1d9e00993f32907ea0fd6fb47ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "150ed5128112728670d002d0e499b64b33cf9580c52696c42a85a2bf8b74eec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "464a7b3b8736329c9415ec9613730f9827cf4481e6907eb51e3b801080b6f682"
    sha256 cellar: :any_skip_relocation, ventura:        "373d66d961ef3d46020cfdfaa1f277b8da454e153ec01bdc7a095297f78c3f8d"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9d0b17b270bf97d46e0a64789b3fbfcc779586b999f0e14f87246dfc690bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "98deeb2becde902f3ea470330433f430543054624619512b20dc33c273fea970"
    sha256 cellar: :any_skip_relocation, catalina:       "9a71da0f9235ca3ff552451fdc1c5219d7391dd267b09622932077351a793b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2eefc094cd2d2e9b17dfcd46b04652974e73d9cc8c72c77a114eb12fa0e75f2"
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
