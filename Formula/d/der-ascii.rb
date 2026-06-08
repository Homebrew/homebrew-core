class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1ab23597139a6e006efc38e1105b81bf8ca2486c3fab42be7a9ccabb8a1aef2a"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fa6de5038d534489c96633367decdb1dd2c1551858d6aab33217b94be3f5170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa6de5038d534489c96633367decdb1dd2c1551858d6aab33217b94be3f5170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa6de5038d534489c96633367decdb1dd2c1551858d6aab33217b94be3f5170"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f733dbc4b5c511ead29361e1e6d7461f719416def5044b24193eb5336faed5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14497d6a5b43b29de266da7c68f38339f3920299083113514afac90629e2c4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66207c1fead032727e757ade6ffbb02c75c54e97fe39a9a2f4de582da442e60b"
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
