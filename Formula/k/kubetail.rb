class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.11.0.tar.gz"
  sha256 "f7d009cc9824489d183189fe84c0ac6077501a65e9ed5c4cf44d23db0fdd29b0"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a330f832b05405b0ecaa0eb62834fb6040456f33ace2d967f1f64940df63cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6271c4e4d15796de51e0ba91f581a6d24128b5d8389e85b01fc22c85ebddc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71a44c20d7d0ee77e60bb263744841697dc6a239b1d4b6a06f9d7d3684ec930"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4aca94392764ce3d21f87daf0d8e9a58d18385c6bc5dd94a013aae391bdfc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2b34147b428bbc03ee8a44ae3bf1e60c5ff9a4b918edacd83c8994a0482c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b970033e2d388afa4d090a9cbd12b83ff865a6c942494c83b3479d1b8f4d58d6"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
