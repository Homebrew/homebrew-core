class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a046e5982eb972825b2dce80548ff1e77dfdaaea2f3dea016e6e5d376cbbc822"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b1cdb00eb754236e1a868cfffb86d43819837a71a1eb802da5dcdd6dd2cf95b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8e365e76e3e2b3bbc4e7a257dfe3ad1004bf5ffc2163c3852c94dc11f380f0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772811a7e784d95d4215cb5fee17f1fa305f5aa7c7340375b6737573ae4c17c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08621eb4c223ed9171115e5e7cf4db9c408194e43ca76031bc2d653692eaea0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff0a49e6c0567d7992a054f8d2b9b68cd4ed785bb20de9a5d30ab75da36eb63c"
    sha256 cellar: :any_skip_relocation, ventura:        "d1542b742bfab00324695753c04d3376bde37343fd00b0718718c0bd6d8b5426"
    sha256 cellar: :any_skip_relocation, monterey:       "b8ee73142506f7f5830b70a1c5a6a7ea8ff1043c1ec9ce01de0c0669e4873101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3fcb0048ffc0776f975baea12887b6f12c61baa197372041a79cbe9123239cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
