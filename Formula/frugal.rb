class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.0.tar.gz"
  sha256 "ba3dc7674b4ff818fcaea7f6a47782456ef1a272d7ad0195bd0720a6da2177ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2272d3ba8d54dc7d94bc5d2e2ae56cef9fc31c24b58a7aebf5c0b5e1fb514f1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2272d3ba8d54dc7d94bc5d2e2ae56cef9fc31c24b58a7aebf5c0b5e1fb514f1b"
    sha256 cellar: :any_skip_relocation, monterey:       "18175ef9d5be43d21860d859cb389ad4392928c511e3933a0caf27b755e646cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "18175ef9d5be43d21860d859cb389ad4392928c511e3933a0caf27b755e646cb"
    sha256 cellar: :any_skip_relocation, catalina:       "18175ef9d5be43d21860d859cb389ad4392928c511e3933a0caf27b755e646cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c489089ac8ea1d40eb0c945bb7edc21d88a4c86b33133db502e563f8ff8ac96"
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
