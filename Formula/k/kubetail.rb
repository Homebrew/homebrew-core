class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.12.1.tar.gz"
  sha256 "ff0d591fbe9352af6dc2f3035321f14d71449f7d09c7b3c918af3016c7c7979c"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "717dd6e239a45e68ece97265688fea1c44b6a07529280085747b0e0db2e2c115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710079a6599de47d5126cab911b4f4b692b6f0213d1aed68edf2326349cb5038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194398b929ba8aa5af586102c4d040615200fff36cf2c712c8832008cf5decca"
    sha256 cellar: :any_skip_relocation, sonoma:        "88201f21bb227b1cfbf8ae780a2e0e15c411951d14c63bca7cdc18fe636d7701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7eea257b39ad88a4b2566bf7bf32180aaf6ca5c514e01fbe62e45611abcea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "749143efe2df6f2dab026faad224960e578be4bb56234b20f398d08330b333be"
  end

  depends_on "go" => :build
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
