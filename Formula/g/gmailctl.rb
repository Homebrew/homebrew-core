class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "49df3a2fe7929114ec406096d577004a27ad75bbb4c836ca603dff88c1a830bd"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a5e37e6b02533386d57c745c9332b4cdd37a2e3b9da3958fde6079ac50f6be1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a5e37e6b02533386d57c745c9332b4cdd37a2e3b9da3958fde6079ac50f6be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a5e37e6b02533386d57c745c9332b4cdd37a2e3b9da3958fde6079ac50f6be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f10de85da1a397fca0758d1e7f98b0f03461bd13083fa07999100d789a1f3468"
    sha256 cellar: :any,                 x86_64_linux:      "d09620ad1ca56409f7e520c43280907692ae8f9b4cbe0f5d134197ce3812e61b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/mbrt/gmailctl/cmd/gmailctl/cmd.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", shell_parameter_format: :cobra)
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
