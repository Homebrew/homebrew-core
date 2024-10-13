class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b458030fdaf6258fe199e5b183b6e57a716b281472efbfef161a8226322f15d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906262ce021bb1b82d5ac8193ac35cde6283e3b709e8f8577c2f88ae12ad16b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "906262ce021bb1b82d5ac8193ac35cde6283e3b709e8f8577c2f88ae12ad16b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "906262ce021bb1b82d5ac8193ac35cde6283e3b709e8f8577c2f88ae12ad16b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e84b2456ebf6c14329e981217f6bab8a7f6b3343b45f404e4800a03d13947627"
    sha256 cellar: :any_skip_relocation, ventura:       "e84b2456ebf6c14329e981217f6bab8a7f6b3343b45f404e4800a03d13947627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c636719021cea3bee4d5d4a9b5b2fa1a456714bef970bded7b52e0b6b19a1b64"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"ascii2der", ldflags: "-s -w"), "./cmd/ascii2der"
    system "go", "build", *std_go_args(output: bin/"der2ascii", ldflags: "-s -w"), "./cmd/der2ascii"

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/cert.txt", testpath
    system bin/"ascii2der", "-i", "cert.txt", "-o", "cert.der"
    output = shell_output("#{bin}/der2ascii -i cert.der")
    assert_match "Internet Widgits Pty Ltd", output
  end
end
