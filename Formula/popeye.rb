class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "40b0e705cff6a0ed74f29e6a7da8ff98bf8f7e22db92f7fbb90a0dad3cec64fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0056889caaa137180ad74df16bb71c2509ebc8adfac8448a2eda6f82b68f224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad0e5fa0712b70de5a7513736337d6758a23fcda31ed5f7037fa587c9a3f0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99178455cf395f149bdd92c5def1e328359e60e0d35b5717caf1761b6f3e624b"
    sha256 cellar: :any_skip_relocation, ventura:        "e63a580bf553674d4532412778400d55ceada9f585d818395dc498cb84e41f37"
    sha256 cellar: :any_skip_relocation, monterey:       "a13a07bebad928c8308eb4a90336252a201daa68010a04d3ad03db9ec995a639"
    sha256 cellar: :any_skip_relocation, big_sur:        "b361170dc72af70df9c233ddd1594243015a4b62a19c79d4cb7f64df32d79975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6561fa12b2d23ba1d547e5fbd1c9ac19ba6a12902c7c982304d91aeea437b22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"popeye", "completion")
  end

  test do
    assert_match "connect: connection refused",
      shell_output("#{bin}/popeye --save --out html --output-file report.html", 1)
  end
end
