class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1755addd83b7f5d05c2d64abdad16f17585af2a1f75682710826cceab890f825"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b5077ffc5cce456b2e7d4e26d3e72e593e3daec46478cb93f91cc0870061fec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b5077ffc5cce456b2e7d4e26d3e72e593e3daec46478cb93f91cc0870061fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b5077ffc5cce456b2e7d4e26d3e72e593e3daec46478cb93f91cc0870061fec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "164de840aac6e2f4096dc89004b0c91c7e03b2f6fef3013660a0bbdf1d964c4d"
    sha256 cellar: :any,                 x86_64_linux:      "75d785d3aeff2ef1204efc36a730f439bc63f2408a255facd5bc886464775db1"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(output: bin/"ascii2der"), "./cmd/ascii2der"
    system "go", "build", *std_go_args(output: bin/"der2ascii"), "./cmd/der2ascii"

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/cert.txt", testpath
    system bin/"ascii2der", "-i", "cert.txt", "-o", "cert.der"
    output = shell_output("#{bin}/der2ascii -i cert.der")
    assert_match "Internet Widgits Pty Ltd", output
  end
end
