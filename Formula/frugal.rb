class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.2.tar.gz"
  sha256 "c8e4b9a64c08765ad4e758dbe0d537e48c1051f903883ac660108ad6f93fe089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99872532c9bddf1723987d5965b791dc36ef4766835f918108d78b85682e9378"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99872532c9bddf1723987d5965b791dc36ef4766835f918108d78b85682e9378"
    sha256 cellar: :any_skip_relocation, monterey:       "ef443c1198486fde9287bcd164f93393500ffc2cc59ae3639946b07ebbdd2de0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef443c1198486fde9287bcd164f93393500ffc2cc59ae3639946b07ebbdd2de0"
    sha256 cellar: :any_skip_relocation, catalina:       "ef443c1198486fde9287bcd164f93393500ffc2cc59ae3639946b07ebbdd2de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebdc34e96e6b005d7620896d055c65813d03a3de2a8286b589977285ea56e2aa"
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
