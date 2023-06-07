class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.30.tar.gz"
  sha256 "d9b58a8b97eab9291b1311ba784a1fcd51a2947a2465b4c216ee4aa08d9fecfb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3ec57e3aee918415aa97accd47761415214e7490d7a3d27eec6f79902d11898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96cb7cd90c9b08bd62a8d6c439aa597c077f5ef91e54708c7e770fa24c7daccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dd2e3656795754df591fb024e19eb7590f97194d2177fc34e78267dc03b0e22"
    sha256 cellar: :any_skip_relocation, ventura:        "83a141e6dad6bfd86a428429b656125ab72718ff8885e90af72f4208eeb5ce3c"
    sha256 cellar: :any_skip_relocation, monterey:       "a24385bf52306b2e87aae9f269d0079a439dcdd4be7c87439dea6a7631a37d82"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc19669e2384426469c15885a7630ddd14e7bf51982a8fedc0b6e2818588f399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "663033197ae337f4696dd65e12afccb62b0023ac3bec882de08aee8250e177c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
