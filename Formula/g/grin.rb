class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "a1922419ff50850c72078a379e3b686f3568a2e4753caf40ed460fe070634274"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d757c90e87892420e2c36e0810b8d14513718ea4b0e832154b5fb868ce6c0658"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2963c51462616466e7fb099666c18ba2d495170be5bf11e20ddc54e7c9122784"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c397b1921b9ce2627dcee73115b830a49e3e3e8e9a9d72fc152418dc7b7e0a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c32de79f8ec3f7a4854d3619e74d5010b4372f1ca7ad365cad40c2752ffb21d3"
    sha256 cellar: :any_skip_relocation, ventura:        "54b27a903f10214bd233bf10e2d7959f256dbee5a0629a19be67725dc7c7a723"
    sha256 cellar: :any_skip_relocation, monterey:       "1904cc871cb422df72df8d66404a086e9f8ae6ab75046653c314c2210744ebaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34801c65b9b1f953b010df332b11434803647143981f8c30b22267d597f63d3"
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
