class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a046e5982eb972825b2dce80548ff1e77dfdaaea2f3dea016e6e5d376cbbc822"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc37dc4a48f2b06c33690cdd5a737f73f7610c60e5ae105588715da8789ab381"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05c571f6400d6f11ab10169f59a4cd1ec3fcd51159862a9174bd2a6d05417718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8fa3d1f1c64eb438a7857b551f461b42250a4bde7c84a30fc57b96192162b99"
    sha256 cellar: :any_skip_relocation, sonoma:         "957052707d8100002dc937ccafefc72a54a5af48278f7032b6cc892db2d4b2d7"
    sha256 cellar: :any_skip_relocation, ventura:        "6d0314543514b17f7d08436b691ce7c4b8bdb4341ec04067247856f2d5f42032"
    sha256 cellar: :any_skip_relocation, monterey:       "85a0444cb04c2ee9081eb86cfbfbdac5d7b47d610625b37b2ddbd387e1fdb88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d7df83b4ac072d0ccdb843326d3399a8b1caff71cd56222f3c0325438ff042b"
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
