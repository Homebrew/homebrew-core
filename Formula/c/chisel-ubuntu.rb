class ChiselUbuntu < Formula
  desc "Carve and cut Debian packages into slices"
  homepage "https://github.com/canonical/chisel"
  url "https://github.com/canonical/chisel/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "01decc25bbb48c14687f0dbf55caefb24bb9febd0304f2d0a563e25c85c04ced"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/chisel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43499d372255a5e31003b434aee2793d3d132b72da15d5301b57621c979d9fdc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43499d372255a5e31003b434aee2793d3d132b72da15d5301b57621c979d9fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43499d372255a5e31003b434aee2793d3d132b72da15d5301b57621c979d9fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bf3d56b054af0852cd0337744f8ccf4620e6b7e465f6cf68f38015d06ff0b20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1e374454d4e8222ff63ad1b486c5b07de7e696701c8662e642d31186dfec00e9"
  end

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

    output = shell_output("#{bin}/chisel find --release=ubuntu-26.04 hello")
    assert_match "hello_bins", output
    assert_match "hello_copyright", output

    output = shell_output("#{bin}/chisel info --release=ubuntu-26.04 hello_bins")
    assert_match "/usr/bin/hello: {}", output
  end
end
