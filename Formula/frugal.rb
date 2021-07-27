class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.7.tar.gz"
  sha256 "521e86ffc2356cd19b8c0a62949b50a506d45069166b140e417e3d8784dc361a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7dfb1ca9297822dfcce5df5911e5efe8c690997311b0fea4c1925ea87ae9c489"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a70a32a4a3bd64c4c05982c9f3e28a243dd91e532f43547b40cbce51601fada"
    sha256 cellar: :any_skip_relocation, catalina:      "8a70a32a4a3bd64c4c05982c9f3e28a243dd91e532f43547b40cbce51601fada"
    sha256 cellar: :any_skip_relocation, mojave:        "8a70a32a4a3bd64c4c05982c9f3e28a243dd91e532f43547b40cbce51601fada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b0b61da8d6b2ce988cc0636805c293e17e6dc4001a4341faa7fafb6717d6d6"
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
