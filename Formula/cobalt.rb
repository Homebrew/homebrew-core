class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.10.tar.gz"
  sha256 "8c767705ad6fc1b1a0824d16c8722b6ae8f12fe1e297e457665192c7403bf27a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e32b08175b7703c81e8870488800d3a1a765078a06adf4a63f98e49e085355a4" => :catalina
    sha256 "0391bf28993d768df82d8fcd26ebe6642bf207d595a9b851409ad25b0f030377" => :mojave
    sha256 "1ff7d22fabc8c4a2832ef6beb6190b2b2501485e384e2a2fe3df292eb8e1ec57" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
