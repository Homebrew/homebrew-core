class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/32.0.0.tar.gz"
  sha256 "584c7f1178bedec605a2487abe3f7909b05a9d13eff878edca2be4dab8f489f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c190a4979e95feb3b0449a0d8a54ef6b232929163957276527ea72a87b600bf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c190a4979e95feb3b0449a0d8a54ef6b232929163957276527ea72a87b600bf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c190a4979e95feb3b0449a0d8a54ef6b232929163957276527ea72a87b600bf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "272dd116fdec010fcd768502a398242c144e95792bea93889ab688efd19036b8"
    sha256 cellar: :any_skip_relocation, ventura:        "272dd116fdec010fcd768502a398242c144e95792bea93889ab688efd19036b8"
    sha256 cellar: :any_skip_relocation, monterey:       "272dd116fdec010fcd768502a398242c144e95792bea93889ab688efd19036b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a2f1240235ac22bd0dba9658f52c82c4d16ab42ee1d57823fc454d3aa4d9fa"
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
