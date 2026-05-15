class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "0e1f78b59cbb05d6e010bab8b7e7ac79cf796771dd9888083c23f99b5080fbc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0fb83906434b132709f5adcce9e698b31d952325905dcf57134ee9c40f8fea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b51faf9437847071fb9207d07769ed617ed02d032427fcc3c3ff96e12f4341f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "747691be9c4f67f22aee54dc64df3db8061e464c871c9d332d1f98b94b1cf631"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6abc496d862c084be4f22cb337758b284c30934620d261ae80d9693e0ce5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9635e568f9f3e645241d35780e7b56a748545336b67cf15d8704b22c7f78ad3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c0583afa9eea22461074fe4847182493c3afec7f3558703fc33497ba2fb9dad"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_path_exists testpath/"grin-server.toml"
  end
end
