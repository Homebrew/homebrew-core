class ChiselUbuntu < Formula
  desc "Carve and cut Debian packages into slices"
  homepage "https://github.com/canonical/chisel"
  url "https://github.com/canonical/chisel/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2ba986f2aeb34434b32f1b6b5cd75cbbd22d537ef9698a8e14c30f40c7b55380"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/chisel.git", branch: "main"

  depends_on "go" => :build

  conflicts_with "chisel", because: "both install `chisel` binaries"
  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "foundry", because: "both install `chisel` binaries"

  deny_network_access! :build

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/canonical/chisel/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"chisel"), "./cmd/chisel"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/chisel version").strip

    output = shell_output("#{bin}/chisel find --release ubuntu-26.04 hello")
    assert_match "hello_bins", output
    assert_match "hello_copyright", output

    output = shell_output("#{bin}/chisel info --release ubuntu-26.04 hello_bins")
    assert_match "/usr/bin/hello: {}", output
  end
end
