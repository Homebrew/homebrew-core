class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.10.tar.gz"
  sha256 "982fe4e84aaadbcb04ee5bca2f7859b9e789d172e6b8641dec447246f4567aff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f360ceb702c7470ef11686878e02ae18ee8a9fbe303933266bc45c001812a31a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f360ceb702c7470ef11686878e02ae18ee8a9fbe303933266bc45c001812a31a"
    sha256 cellar: :any_skip_relocation, monterey:       "6848576f112c4a64f42eb5c4942e21105bfa9ab4baba5ddf71b33e46804edd09"
    sha256 cellar: :any_skip_relocation, big_sur:        "6848576f112c4a64f42eb5c4942e21105bfa9ab4baba5ddf71b33e46804edd09"
    sha256 cellar: :any_skip_relocation, catalina:       "6848576f112c4a64f42eb5c4942e21105bfa9ab4baba5ddf71b33e46804edd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56e37ecf787cf85d25cf0dd0f5dd9c22e54d9985d0f45ec1cc30c5d1f609f4b5"
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
