class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "720db31f45583c5fd35e2a31848682ee9bbbcc24e256157482b6b8023fcfcf10"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f26d0ab2b3c627274843cbc067d33ba3b3e9165c929b8232ea352ab4e9b4bf95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cdcd2424cbc89ce8cfcdf8cc315df8c37e91e724b5d01dace02297fb4c5058"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6cca7b4cd039a1c9644b8d262c43f970998669419fab769d7791045691b51b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3393e9c3a1a9d2e95c64ed5c5d9654a09e8f2c68e8348940c270be3de1011383"
    sha256 cellar: :any_skip_relocation, ventura:       "000d11024d6908d84a2b23ae1f602a0e18893ca8777fe13842a729b5a19a5e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ab581ac0c2751a4e9427e596d296043f596b4ff8dc7a108d81db7f29f6dd6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
