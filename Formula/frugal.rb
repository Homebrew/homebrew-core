class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.14.tar.gz"
  sha256 "ce41f26a39dbfa7f27309c9ce56e0ce62e95bcc563049f2c96953f36731c962a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2747586a103d32b26754fd8af3d477d156ff75439a6b2618807177a4e5e95469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da88a1403b34cf25d7d177732914df43db7da39101e610d27851586e06d8b40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4665cecb7d685f6c648f837b4603cbd93186072f79e4c589987719317cb9bae5"
    sha256 cellar: :any_skip_relocation, ventura:        "b48ae95989d019a69c0cd9636a576b66256df1cb43e221d5a282772e9a5bb9b8"
    sha256 cellar: :any_skip_relocation, monterey:       "c24724e5658bdd638a0c082386d7d1de710d4a5c3e9df5b8b611656c9ca705c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f214659b1f7d4d1f3332f339370060503bf5ec6470cc084530aef0e2ad9628ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "878f14965809634e930d60f1b83c25569b9fefc501846c882f576e085ab2f303"
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
