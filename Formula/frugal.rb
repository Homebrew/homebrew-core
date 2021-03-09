class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.0.tar.gz"
  sha256 "3846b10ca61956f3e6ee33991620fab1b58b28d9131a55ea0db3a50f301fb263"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "318f2abc0180a6145d07df9eb38392d188ce73941b48a69f8327d073912c05c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5091ce489760e134a319e1fd95876074e2570aa6df5ab4a5162c04917bf172e"
    sha256 cellar: :any_skip_relocation, catalina:      "a29e67a857b219d854cca711dd47b7bf3a0c8762b57512334fbed946ff74a6d0"
    sha256 cellar: :any_skip_relocation, mojave:        "5e2e9a28e4bfea849d62a88a309082f8ec1c40a6f7db6b68df0ebde1f88aec21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
