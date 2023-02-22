class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9b392ecb5db6917283f5186c0bd9eee43c04f8c6a0a139a11bf8dea323f717c7"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13c487d7bfd50229d2a9718e433646be3f3b70deccb25ee7e6ac397be533575a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f1d048c470851fb719fd0ac0f16262cdde3f94c66b2642a133258b6fcb5678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38a809afdeb8a95d1513595e0b0d93784bb0678e16b9265d3507d9a9aef76263"
    sha256 cellar: :any_skip_relocation, ventura:        "96b2b9c72b458959f5fdeaff638e7c1615e6528192006423dc37fad479581f41"
    sha256 cellar: :any_skip_relocation, monterey:       "3b66acd619b459ae116da5482cd90d72df0fcd02a89e66d7e754afc4802ec8aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "17cc8dabc07c6988541ba3980743509d157e41f4ec873f4cf32932f3d04c529d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d188affbb252fd050c2973dfdc992352f4e949e2db6ce7a5707191f2fb1102ec"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
