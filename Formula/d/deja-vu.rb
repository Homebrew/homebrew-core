class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "539b04501ff65b6f63f2af20fd795cc22bf98324c61f760d14f55143ce96da0d"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2186bfbdb3bb52ce9c6bc3f678b6c8eaef5e77e13e1507f6476b6721e12d94b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2186bfbdb3bb52ce9c6bc3f678b6c8eaef5e77e13e1507f6476b6721e12d94b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2186bfbdb3bb52ce9c6bc3f678b6c8eaef5e77e13e1507f6476b6721e12d94b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e95ba8b82f55267117f1c9a39c98f3b76ef20f5f0ab7e306aa9f279db9409777"
    sha256 cellar: :any,                 x86_64_linux:      "5160d684b064de9fe4dd5bb67553e934c7d6078936af4a6c933f64cba777bab8"
  end

  depends_on "go" => :build

  conflicts_with "deja", because: "both install `deja` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
