class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f1f025c037ec98f929cfad914a68e923311d438ea9f043e662b536e0eeca5934"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2c1a0a050e05a8488cae29344baf14c2544af988674fbb7bd442cc6e1895f9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50286eeee5fd0adebb48ba4504fc04053864f19f836a384eb15a1ae609cca603"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2970f3988d92906627929a03ebb9d99c95268db0b405b2fa2d8dc25c9dd43db2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1323d7b7d8c0d78190c62e086d1d7364d2d9bff5ebeaf424abc680f5e053353b"
    sha256 cellar: :any_skip_relocation, ventura:        "7440eef08d0c0f578187125213094adebe5eb753e62964a2a1bea3a3e5fe453c"
    sha256 cellar: :any_skip_relocation, monterey:       "3865e39e31aad4f29dd058e2b6bb3db7c24812664b0ba8d924c9075b3653056c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a264a0015e50f1e10723f9dc795998e1050571c917d07d3427b387fc1da35814"
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
