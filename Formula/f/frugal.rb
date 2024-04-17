class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/refs/tags/v3.17.12.tar.gz"
  sha256 "54eb159e726b816c91910c0a61da176ad5a5057612118a5df6cf5ff562f237a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "789b00fd33c8679863bd986eab2f642c9d2350b1b5f91303e3c138609439134a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "789b00fd33c8679863bd986eab2f642c9d2350b1b5f91303e3c138609439134a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "789b00fd33c8679863bd986eab2f642c9d2350b1b5f91303e3c138609439134a"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e6089120444dc33827226e43c981aea6f94e42021030e027e8955306dec912"
    sha256 cellar: :any_skip_relocation, ventura:        "88e6089120444dc33827226e43c981aea6f94e42021030e027e8955306dec912"
    sha256 cellar: :any_skip_relocation, monterey:       "88e6089120444dc33827226e43c981aea6f94e42021030e027e8955306dec912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a72c420f2002d719f16cfa7af3af0b10ee72dfa3c281ca9d0dee2c7e965a8b"
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
