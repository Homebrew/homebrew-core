class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "8ab201b539c8f950fd10a03c4600341d5bc958630ecefb67955521959ccc7d54"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01c87d7a6ef24d9ade343e24f3c344c85a6f8124229b3adc00c7230270ff5b44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37922f35615f5ac0717b34c9c067e0389d443ecb8d04ef91a3073e1d9fc3b21f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a9350d92fc33bd60de6c67092fbffa3c2214f7e0a344d68d967d4b488899d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8229f8411b9ebb16011e8c5e498ade378e995971b7af2156cfbec18621ed06de"
    sha256 cellar: :any,                 x86_64_linux:      "63b7cccea6a316cf2ce536f8913f1a6b1859ea299de755ebb16b7f021fc3d7c4"
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
