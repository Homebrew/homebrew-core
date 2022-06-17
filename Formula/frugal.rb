class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.3.tar.gz"
  sha256 "f1be36f112748f4f2423600d5f1c29822bfca414ee6feaa555ec884813feb47a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d90cc8d840c590ae5e744853a2cc0a1cae22a9c66e0221f49f43b71c0399683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d90cc8d840c590ae5e744853a2cc0a1cae22a9c66e0221f49f43b71c0399683"
    sha256 cellar: :any_skip_relocation, monterey:       "b98bc4ff4bff5d392dfe20a481b7be8add2f62cd3e412803cdf14e0bfc535688"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98bc4ff4bff5d392dfe20a481b7be8add2f62cd3e412803cdf14e0bfc535688"
    sha256 cellar: :any_skip_relocation, catalina:       "b98bc4ff4bff5d392dfe20a481b7be8add2f62cd3e412803cdf14e0bfc535688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e51f25a67c83db4e3f973245e3c3c787d55f3721465ff41dd341e999fb4b5cf"
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
