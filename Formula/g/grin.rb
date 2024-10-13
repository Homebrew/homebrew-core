class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "f10bb5454120b9d8153df1fa8dd8f527f0420f3026b03518e0df8dc8895dc38b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "721f60007ef15d390dade33f2263a7d1d7d99dc35944824ebc29d78f64b2869f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcb00117fbbd30fd499af18797efaceeb80ac034a5e209e3747bfb4303c2e609"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c0b317cc1b6d3121b628c7a86429f400f7e4247d6f374c0bbf94d553c0bb794"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c5456560cd5e0d35a0086589fa709947091647545e4b5a50be3a3cf423e57b"
    sha256 cellar: :any_skip_relocation, ventura:       "95c878f8c5a355046aa021e41a96f607bd893df168124b5e8930f048709947dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4c00e5bd2c766ae605b711264ea3c55f76c5a39d5761cb9ec34b971d90e3e0"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
