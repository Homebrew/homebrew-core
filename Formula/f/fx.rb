class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/34.0.0.tar.gz"
  sha256 "a1d436a8951a753488adda02fe9fb1091fabfe928eafce73f3b1e690a9dccbee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48de944b02718c8c55662ad58a2b6343884be96cb5a8c926189ca36d742265a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48de944b02718c8c55662ad58a2b6343884be96cb5a8c926189ca36d742265a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48de944b02718c8c55662ad58a2b6343884be96cb5a8c926189ca36d742265a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "94f465f85daf21ba6930a33ea67353f12912c8242e584961d26bc347aaae30d9"
    sha256 cellar: :any_skip_relocation, ventura:        "94f465f85daf21ba6930a33ea67353f12912c8242e584961d26bc347aaae30d9"
    sha256 cellar: :any_skip_relocation, monterey:       "94f465f85daf21ba6930a33ea67353f12912c8242e584961d26bc347aaae30d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df1cea58e1293d847dfefc5560e90edbc1ffa309a9870de4f0e6fc06e87641a"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
