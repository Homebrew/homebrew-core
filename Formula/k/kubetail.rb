class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.3.2.tar.gz"
  sha256 "bb2773721b9089cc35abc58c0bf093a2d348af99408fb5461e94a04b01cb38e6"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d557655563567528d1b88d8c4da0db57b7289d39a3de9f75bb937df872ae14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52db3be0cf8f41ab95684c28d7c0cf34aa00f6f828b5d19985efe2cea17467a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4ea1bbbbce2632a3e38fa58a6275e5bc96e76f8cf2da8a30a7143849752b3f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f4aade1469f554b82ae7db5762a9d5574273b1f57c2720825814cdb7e34e87f"
    sha256 cellar: :any_skip_relocation, ventura:       "53fcc4c78217822ffa9e7cf0904364bfbf0a79b91f55aadbade282c500423d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8704795cc741fdea87f0f1e3dd160b1f1941251b5f906b8ffa5e1dca04042c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242eb2c82a9e1974abf4c0f564760c246a5e1c82c67f920f54ebdcaf4ee7b1c4"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
