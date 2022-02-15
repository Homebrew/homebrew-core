class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.14.tar.gz"
  sha256 "07787b6f8a26799dee4abf6cc92430e4f31f3e02c63abb3417a6dd7f309f0391"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f575e917ff1867a686adf9f072443b36592ac4af4c28344e8acfa49c5e14850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f575e917ff1867a686adf9f072443b36592ac4af4c28344e8acfa49c5e14850"
    sha256 cellar: :any_skip_relocation, monterey:       "3b0bffd77b25a21eda9dc1a54af113ddadedf565e211f61411223d7948fa5b47"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b0bffd77b25a21eda9dc1a54af113ddadedf565e211f61411223d7948fa5b47"
    sha256 cellar: :any_skip_relocation, catalina:       "3b0bffd77b25a21eda9dc1a54af113ddadedf565e211f61411223d7948fa5b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068e167af836f25aa0080eaee9e0fedb85f61c0317230fbac5d9428e88b574db"
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
