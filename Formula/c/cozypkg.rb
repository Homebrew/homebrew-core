class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c0cfe16962c2501fa6db3e6f4b925ecbd28263f55679246be46167345d1b82a1"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6fb6fc7240cbae281703b80c856acce60e19b68f12d77a90b7031177fe2fa74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b5e542fdb1ef1e747d9d9e0fa0462e3e258ce5a5d47e83bf3ffbbaf65022f28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a7d0ff53fb66369d9d900376c5c8e7e59d19669a308d6d45e76dcb4febb40eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77eef4ae8169bb2f16becb0099b3e563e58bd6be4e0bdb200c422b97d0abe891"
    sha256 cellar: :any,                 x86_64_linux:      "2a8939532d23fa66899ce4d7f5131299bad8648dbbe5ccf3312e7024148953f3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
