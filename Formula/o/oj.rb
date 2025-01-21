class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "3b51d0d9aa52810544e499ce42a5952d22fe1b9fec4159baa39970c07a62e291"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "739277d80e25b2b003ee36851b55516cea743448d046f0b47704063f1ebf7c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "739277d80e25b2b003ee36851b55516cea743448d046f0b47704063f1ebf7c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "739277d80e25b2b003ee36851b55516cea743448d046f0b47704063f1ebf7c6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "977dde1e7d79fe0881f2a594a3ac343dcb74ba82a33335a35105161fdb16194e"
    sha256 cellar: :any_skip_relocation, ventura:       "977dde1e7d79fe0881f2a594a3ac343dcb74ba82a33335a35105161fdb16194e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e9fef9bd8e4b5ae3d9cf40b015b2eb9f2592b073e0775d5e84fde68ce3aaa0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
