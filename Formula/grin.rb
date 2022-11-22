class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  # TODO: remove the `cargo update` line when this is next updated (5.2.x).
  url "https://github.com/mimblewimble/grin/archive/v5.1.2.tar.gz"
  sha256 "a4856335d88630e742b75e877f1217d7c9180b89f030d2e1d1c780c0f8cc475c"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d3e499b338d6eb3a0921258ea0876261a18a7957b4338b382278f7f099ec062"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6664533cd67da4715371d48f3bc8eecef589cfdd2efe5e19af14472f91f0bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "064eb5619f52ca1f2123ee82e6017e6380889b38b87b9654f01a946ef31bf0b8"
    sha256 cellar: :any_skip_relocation, ventura:        "acfb62e9c0cc12c65c9caf71d79b371209017d6434c6f91a98c01889828472c4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf3066f5430c31b31d00f9c1f56b0e4c5824efd00606231d719dbe24ad1c4de4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4bea4bf9a3195bbe5aec65908e60834b2a55579f88c7ec9fe5856b2d8a009d"
    sha256 cellar: :any_skip_relocation, catalina:       "45d21d3e03f2af974b5ddd36636c013cef9beedbecab2cfb0606168a77981f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdcbd7bcb60160cbd90c54e362650a191b64fb33d356991896c0778ced854ecf"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    # Fixes compile with newer Rust.
    # REMOVE ME in the next release.
    system "cargo", "update", "--package", "socket2", "--precise", "0.3.16"

    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
