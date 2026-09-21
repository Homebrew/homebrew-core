class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "a40ecfff3222c9303c4fd0fb7aae9aa60f74bb7a7c649df661daaf5db47c6f80"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97f8b68f7de57c20e8ac42e0ae350ad06e03d444497f880f76bf4404af930f60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97f8b68f7de57c20e8ac42e0ae350ad06e03d444497f880f76bf4404af930f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97f8b68f7de57c20e8ac42e0ae350ad06e03d444497f880f76bf4404af930f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fb5f602191fa2385adf452f73f36de75309cf0618a92dcaa391dbf07c9f5de1"
    sha256 cellar: :any,                 x86_64_linux:      "03394a2fc51cb2ebf830aee949a01be63c641b025318aebef8f92cd4b34f76b9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gotpm"
    generate_completions_from_executable(bin/"gotpm", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
