class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "72495723a0419026e6f2425b7badfb22dd32ba7563f271bb3d8fc41a614c0d45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fecac1fa9988f090d3827dbc56dc303dc6528c0dc4a80a1ee290e06144ed464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fecac1fa9988f090d3827dbc56dc303dc6528c0dc4a80a1ee290e06144ed464"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fecac1fa9988f090d3827dbc56dc303dc6528c0dc4a80a1ee290e06144ed464"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6e7ec32300338f26c2ffb4d75ebde9e4b7883790bb099c584c1b6243372699"
    sha256 cellar: :any_skip_relocation, ventura:       "fd6e7ec32300338f26c2ffb4d75ebde9e4b7883790bb099c584c1b6243372699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4945d32c1dd55e31b831ce74a1aee82b7ffbf5b9f28db508144d808948ba7e"
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
