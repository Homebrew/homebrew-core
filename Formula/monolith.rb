class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.6.tar.gz"
  sha256 "22a16e420d744aa10af4670ce6a92237d2f3e7851673d02cc5e40651ff4ba347"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3a5cf25857776fd94c616307e1faecee9e44eb40c38b1da811bb18b432c78de" => :catalina
    sha256 "588fd7a8c333646d6fb363b0c150bf094cf1ce7d875c6df303d3fba654e0488f" => :mojave
    sha256 "3a1d416c18dde3cb7b8d6b0b2ee685e0652de64a0793284f12d56f959319e13e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
