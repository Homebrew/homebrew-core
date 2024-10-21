class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.0.2.tar.gz"
  sha256 "7fc8e1be49d12a52bbca8254290c6f068b5652068065f9171a2b88820ca0ebac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab2b9f44508b5b61d00e5ac9a6463a001e73aa014f7720237505ce23eb2f0af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872f241abeaf148005b621fc433c61eab8e693f4468083818926c177b900c3ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1541f48fa591855eff5c63598cb909b47135bddb5ff1697cb1603c3dcae0adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14fad32cfed1c47b47cfb6fc06aac24412bc46719b1c78e1f0eaa906eb8a607"
    sha256 cellar: :any_skip_relocation, ventura:       "e85be9cef859d6259e4376a6a97c6b3b0d83bb39153775925da29853d8bbb5f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1a8afecc1d9249c2b526f91950b3e23e3c33539bfc0fa1584119b332fc673a4"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output
  end
end
