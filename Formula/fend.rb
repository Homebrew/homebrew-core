class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "2bf2c1ac0716db91134b5862192a3c42d1b38612b7a3fd8ea3980fe884ae5ad7"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21d1f0b99f2f40f37d2a4b2a0f534562a7c7fb643bb21db684120af4a5b42385"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4318b51531e2793ea7eee4df3913c386a498d09dd6edd101fbae90a4e50f80c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c89052fbb2cebd5173d2cf35ed61d262ca186aa70cdcd9cf6a5017b20b0056"
    sha256 cellar: :any_skip_relocation, ventura:        "9641c770b264c2cd74113dea0c23dc595811c4782d113db90dfd66f2bad18196"
    sha256 cellar: :any_skip_relocation, monterey:       "b02068772b1f8c0fab6010277a476ccc9d9d5f098f57e23ede5ef9c21de8fb84"
    sha256 cellar: :any_skip_relocation, big_sur:        "72ff807429ebac4e3d4f6e8eb865f1e2f02c10d8005a4211a7123de6619099bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff607bfc01b750cadca8e46c17405bf93dfdb01b673af1d901f91325ca0377b3"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
