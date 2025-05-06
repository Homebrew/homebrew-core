class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "4e5e25b2d3ade22f0dc87264945ece6138858d3c6803143cf39c66183a74c9c5"
  license "Apache-2.0"
  head "https://github.com/google/der-ascii.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6b91afa38381784b23ba412b76988d4ee4c88be080ff8cc83e34925a9a5b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6b91afa38381784b23ba412b76988d4ee4c88be080ff8cc83e34925a9a5b8f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6b91afa38381784b23ba412b76988d4ee4c88be080ff8cc83e34925a9a5b8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "be6480d41a86adbc097cb14c49fae031990959b144ea5c23e81254e9394b32a2"
    sha256 cellar: :any_skip_relocation, ventura:       "be6480d41a86adbc097cb14c49fae031990959b144ea5c23e81254e9394b32a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bca066b2304679127bbf35d34a9ecbfb5744d4fa149a373bb3651b47d0d88b6"
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
