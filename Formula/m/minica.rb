class Minica < Formula
  desc "Small, simple certificate authority"
  homepage "https://github.com/jsha/minica"
  url "https://github.com/jsha/minica/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4f56ea73d2a943656f8a5b533e554b435bc10f56c12d0b53836e84a96b513bf7"
  license "MIT"
  head "https://github.com/jsha/minica.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c9feab61490a6975219259e16f34d0d1f283775bf3554b77f56f3796958162a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9faa299c46a22bc87e87ed7a480449aa5642a0e110f64cd6d28e12c305d9ecc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc8955ffd5c34b8eaedbc556e71188ec55c2a01e76c26f853aeb0038c7ac2426"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa6002d59696edcfa6929d19a51a99260f472d1c492295c6c38ee074c381d0aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9317695171ce2314300613641c494762895bf1954560e53546c44e0d9557ea83"
    sha256 cellar: :any_skip_relocation, sonoma:         "e65d5ccc5f4703009f8b2d0a460dc883711c71a4814c06921c2ea98dfd797f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "93d40ba3ada1bee8b74febdd40b3bf37a4bdd91a24d4a62f342314a9d85cb736"
    sha256 cellar: :any_skip_relocation, monterey:       "6769f28dbd2b0295f87d007007b9cb61d5715e93a9b13f4b25de9466083fdc23"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7bb26e4da3fb0a4744f488416535864c2ef4b8ce4622f95cf591b76a18e2e03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea318ca6a9231fd445ec38d2905f6b5de30ce697dcedeb9d8ae5127f9634500f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"minica", "--domains", "foo.com"
    assert_path_exists testpath/"minica.pem"
  end
end
