class Nats < Formula
  desc "Utility for NATS Server and JetStream administration"
  homepage "https://github.com/nats-io/natscli"
  url "https://github.com/nats-io/natscli/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "808a8905383949625e0a3f86821865eda29d381274021ff2d9ea7d7448c951fc"
  license "Apache-2.0"
  head "https://github.com/nats-io/natscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0874c83c1bd1c1cfd4a135c4cd47796242e129e82e1e2594122422e4a4b84751"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dccd6710994aaec87c4303f4c73242bd6f2c2773a4232a7a02a6a81ffd1c64e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b0b07f92419d681e843a8e703a6a71853fa9180353a92722152bb0f75dbfca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb2374380592382003ba5ecd19cf300acf4c6128ab72f489d034b9dca2a7af8c"
    sha256 cellar: :any,                 x86_64_linux:      "56d346fecdd7ad842af7212b93d4f6d2ab4b88771e79e78bebb30e5dac1dde97"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./nats"
    generate_completions_from_executable(bin/"nats", shells:                 [:bash, :zsh],
                                                     shell_parameter_format: "--completion-script-")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nats --version")
    assert_match "No known contexts", shell_output("#{bin}/nats context ls")
    assert_match(/^[A-Z0-9]+$/, shell_output("#{bin}/nats auth nkey gen user").strip)
  end
end
