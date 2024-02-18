class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https://popeyecli.io"
  url "https://github.com/derailed/popeye/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "9f456ebc8fdb3c9fee8ecdd102832f1217da26a41548376d16925e9fbc1abf9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61586513fce238ac70a45a1f55417cdb13d69c58f1e55556818580fdd72bb4f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a705fc75e71873c95b38a695d0831f1ff4ea3c8910a93f30c99de77173e99f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa89e724168c10e45e81bf45156bb4688266e7ef19e58f3c59af39150cd4553f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0817d95b11aee74d3e9ced2e085b987fb6a5eb713b73d1f04c44f9816a1affda"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7297c6af43af341c7e95b4746eaedfc5cb8eb3226b702d61fc9a4647be6c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "e900e31b465b92e063c5a479b440780b7a261f2d8ed23affd28d29fed519e909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7415875c1417458ccea2d4645fe7de0f496040e500fe5025986d995868eda08d"
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
