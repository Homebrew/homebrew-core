class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.8.tar.gz"
  sha256 "94fbca185bb38989b7b3345da76a29bfd7fa5c984226aded967856ed34e25640"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d9d9f39a512e095001cb01951ac953b7ac0063cf12a5ca68e6829dc2b2ddfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67d9d9f39a512e095001cb01951ac953b7ac0063cf12a5ca68e6829dc2b2ddfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67d9d9f39a512e095001cb01951ac953b7ac0063cf12a5ca68e6829dc2b2ddfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "454dba89d070f377c33d4696092d5f66a2dde91b73c43ec989cab46aa0257229"
    sha256 cellar: :any_skip_relocation, ventura:       "454dba89d070f377c33d4696092d5f66a2dde91b73c43ec989cab46aa0257229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7059d120ce3a79a4bf7e44ae00f069b1f2e2a2a7065232db101adb8459acead8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d813df6941d8de2d93a206e8382155282de1d5e6751e4efe5f2a1a7fa9d597a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
