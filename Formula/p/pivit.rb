class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ad52207e4962969a28aa298098b0a360ab6ffc61e4e075d9e0842adccbac4a29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7f5d747e5dfa387783b29019ed02f78ef8622d71abcb851ecf519e010a2bea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89f12db02ef6895b23cd60f5a6e401601c04484cca4d6be2d4a79e7541d9bd22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d40cae5fe5369218a74a74f5abb473a11a867d2013333de2db720aacc735ef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "acc9b73454be913f494d087148ca8d72837da35ebf8b49d6a54d689de5eb6492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ed67ed542f89456ab252694a290eaf2e9da1f8833300f048ad31a82258584d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64fab27f7aeb2ca8f09732a8e48eb090591a0840cf51106953e9774717230f17"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pivit"
  end

  test do
    output = shell_output("#{bin}/pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end
