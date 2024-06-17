class DerAscii < Formula
  desc "Reversible DER and BER pretty-printer"
  homepage "https://github.com/google/der-ascii"
  url "https://github.com/google/der-ascii/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "03df9416db34aa9a7b0066889e938e318649f4824c6f8faf19a857e1c675711a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04be50b0ec21794ec21769096bd228628fa8a1627a0098e10342eb15748bb850"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04be50b0ec21794ec21769096bd228628fa8a1627a0098e10342eb15748bb850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04be50b0ec21794ec21769096bd228628fa8a1627a0098e10342eb15748bb850"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d9172b89c6b4fcfc1fcc8a8e08cd3a186612c31d624ca3296ecd0a7699d1dfb"
    sha256 cellar: :any_skip_relocation, ventura:        "7d9172b89c6b4fcfc1fcc8a8e08cd3a186612c31d624ca3296ecd0a7699d1dfb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9172b89c6b4fcfc1fcc8a8e08cd3a186612c31d624ca3296ecd0a7699d1dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7561e7f5363505b25a4173b27f3aad87c893ab3d7d4c6eb1cef272afc2712b51"
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
