class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.4.tar.gz"
  sha256 "6c711901bb094a1241a2cd11951d5b7c96f337971f8d2eeff33f38dfa6ffb6ed"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb64a05eb364d4ee0409d9f5752f3b63d5e4cc7ae26ce30bf41bc5d80bb9a2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "002ec97eb8825f58c90bbf593f45f2095ce18986be772dcdbcbf22b4d769e82d"
    sha256 cellar: :any_skip_relocation, monterey:       "11217871e6ff4f47e7cb65775de7ae9ab38da4cddc57c1a995a98fa589eb647d"
    sha256 cellar: :any_skip_relocation, big_sur:        "327e73dce8b26e4175f40b0734337061a29d996a31ad45a818665bc50dea645a"
    sha256 cellar: :any_skip_relocation, catalina:       "dc16f5b42718beb69bd573194cbecee6a3047d6fd806749ba62dabfa806accaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbabf1dd52809512aa0a0c0734948413524ccb606daa551309dfceecd75017f8"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
