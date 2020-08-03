class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.2.tar.gz"
  sha256 "0410a48a9ad276b1fab82b9a3b0548f896cc0c403d3e5c62480e3a74c79bfbef"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2fc9bd29b0ec14e58a2c8023f0b756981c7ef0852710c0ed0b20ddfc030c3a7" => :catalina
    sha256 "7a91ed4fbbaf00ed8bef44aadcffc70438b89f640f4a8e1b8bf25e907b297b11" => :mojave
    sha256 "244effddb9e91161fd9025fe4b35875ba8eaf19b19a73913aeb34d4fb8dc8a54" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
