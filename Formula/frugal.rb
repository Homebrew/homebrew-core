class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.6.tar.gz"
  sha256 "825e24890ca62fd4bc14b422ecba9894e98a6c3e4e1b6e90719892660278e125"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621fdcb095a5e7be225893629493b06fc258e7ae4585af3e700f2d50f76a6f58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083b8cbb7a0beb1bf21a660c44035dd8f7c1b6878b464c4ac3f91c53c204c9fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09d63e6337c4f5d31c151a7f6da50d6c0310a69299335e3875e50e508dd153c8"
    sha256 cellar: :any_skip_relocation, monterey:       "58d728ad889ae308f2e2e32c11440e590ee3ceee218e6fd2c4dde3a1e216b6db"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0f95004b4d091a693d49e5d79480f3f28642d0e220a24a7235e2f5ae19ad31d"
    sha256 cellar: :any_skip_relocation, catalina:       "0f6da20fd9f8967bc0a76249e64380f284c533458b8dd5353c724821dd3cf9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f585bb9335e6cf3e20b19f4fd2c6fde02588703ba08dde2cf04317a47c34f734"
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
