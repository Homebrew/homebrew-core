class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.12.tar.gz"
  sha256 "98808cd15fd88b2d32a79e2305873a9081d7ec9711b325893677d9649de9185e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f258b1e10ffe78dceec5748d4c8e1ab37ed8f5e2920c596b6962d33147588a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f258b1e10ffe78dceec5748d4c8e1ab37ed8f5e2920c596b6962d33147588a"
    sha256 cellar: :any_skip_relocation, monterey:       "238a87493c59a531285ddcfab2560cd447cb672db7df830d8c8581eaa61a2a8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "238a87493c59a531285ddcfab2560cd447cb672db7df830d8c8581eaa61a2a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "238a87493c59a531285ddcfab2560cd447cb672db7df830d8c8581eaa61a2a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae706df4641cb081fa248d82b9565d507d55a8ff5f6730e14e2b8ae2f7b6527"
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
