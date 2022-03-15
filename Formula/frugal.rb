class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.0.tar.gz"
  sha256 "a7f97de2dd6765bf166d5763a44bdc30cc067b06d3f236cb1715c3bed5a0e557"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43025724ab5a12edf6630b73b31da54cf3cfdd4e917dcf1ba8feaa6ac164ade4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43025724ab5a12edf6630b73b31da54cf3cfdd4e917dcf1ba8feaa6ac164ade4"
    sha256 cellar: :any_skip_relocation, monterey:       "bd76c5f9b3be90c91bd7f48b1e294ff753bbc425e0aca9179e4269a1e9cfe684"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd76c5f9b3be90c91bd7f48b1e294ff753bbc425e0aca9179e4269a1e9cfe684"
    sha256 cellar: :any_skip_relocation, catalina:       "bd76c5f9b3be90c91bd7f48b1e294ff753bbc425e0aca9179e4269a1e9cfe684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a23ba8a889599d792c3e4ded8784376e0591252539e576155cd3b0a9119c8c"
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
