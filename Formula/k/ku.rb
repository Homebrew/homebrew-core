class Ku < Formula
  desc "Keyboard-driven Kubernetes terminal interface"
  homepage "https://github.com/bjarneo/ku"
  url "https://github.com/bjarneo/ku/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8ee6560203f5a2aebea6cd22b1349ac22745899cd37dbe76ddc611c4ecb1c075"
  license "MIT"
  head "https://github.com/bjarneo/ku.git", branch: "main"

  bottle do
    manifest_sha256 "208089f6d6209402cef8c020049d6349be1fb04be1232c5548daa7105032cd52"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2929d7813a8eae3e86e2bcd325be5fb3973d102e3c179e39307dbfe3fbc11775"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2929d7813a8eae3e86e2bcd325be5fb3973d102e3c179e39307dbfe3fbc11775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2929d7813a8eae3e86e2bcd325be5fb3973d102e3c179e39307dbfe3fbc11775"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f4373d5ae867f7f3e0ebf2f2224ed8ebde5b605d6932e1a806e0259b4d72e86"
    sha256 cellar: :any,                 x86_64_linux:      "87dff6fd8dada698ddf75c6323d21021ec7ffbd879317062ec153a8903e91f90"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ku --version")

    (testpath/"kubeconfig").write("")
    output = shell_output("#{bin}/ku --check --kubeconfig #{testpath}/kubeconfig 2>&1", 1)
    assert_match "kubeconfig is empty or missing", output
  end
end
