class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.10.1.tar.gz"
  sha256 "ccd23b01f22607e4b545b3eb736e13b9dc1adbf7511d86db90dfd1aa22f6b14d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58a35ea950a28784ab14e1f4406381f4c22fe3eee9ffb6625cd1ad3068dfdf81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b7595dd23de208fb999df4e91cd7a5a61042449943196598f0b293b8019bb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "519402fcfc9d229c5ba00cb1f8b3db3016fe55bde344211d992276bd4b461206"
    sha256 cellar: :any_skip_relocation, ventura:        "f47d5b7709dcfab879db800cbdd4cb7df03370e233e82e91bc267e4fd50d49c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b6547676931cb3073055383b05d6ae2bd034249ae918508505e99a888bc82c31"
    sha256 cellar: :any_skip_relocation, big_sur:        "11efb86629f7087ae2bdf2ffb7e30a423bb0953be635a750e4e3dd3ba6e28c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d26eb75cc838dc59fb5608e100afd5dea965363259daacfeb1bbdc9b1a0a425"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end
