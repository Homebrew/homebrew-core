class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.0.tar.gz"
  sha256 "a7f97de2dd6765bf166d5763a44bdc30cc067b06d3f236cb1715c3bed5a0e557"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6411d232f8e449cf7add2f3a8e625c4ffd7ff36b6c0fa342a5816f58882267b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6411d232f8e449cf7add2f3a8e625c4ffd7ff36b6c0fa342a5816f58882267b"
    sha256 cellar: :any_skip_relocation, monterey:       "46d1ca2083d1073277cab4446d4ce24f43a36097892015b2a8f4fb731fa51d31"
    sha256 cellar: :any_skip_relocation, big_sur:        "46d1ca2083d1073277cab4446d4ce24f43a36097892015b2a8f4fb731fa51d31"
    sha256 cellar: :any_skip_relocation, catalina:       "46d1ca2083d1073277cab4446d4ce24f43a36097892015b2a8f4fb731fa51d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4798bd6396e7a10f9b31ed9fe62b1f1b1ef0f683f988f1a812991dbb7f4a7576"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
