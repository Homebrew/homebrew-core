class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "15e7268f6ac03617080751be9208df04a6d431d86c72c4ae5d8334e01b03c4a7"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fae19ef6e6b9ba686dba87022f687be7e7a3aff81586d57a1fa08f89a752b3fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fae19ef6e6b9ba686dba87022f687be7e7a3aff81586d57a1fa08f89a752b3fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fae19ef6e6b9ba686dba87022f687be7e7a3aff81586d57a1fa08f89a752b3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a18063794b78599ac1b0a1c65dbfa24068970bd4cc73c53207547a791ad1275d"
    sha256 cellar: :any,                 x86_64_linux:      "8bcd0fc7e7d02e888601b4a7131903183bb567f20773de829c78b083b28bb8eb"
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
