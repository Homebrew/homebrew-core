class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.2.tar.gz"
  sha256 "224ef6cc7fbde12b3d0d6f0b6758ada40848423e707af0a0b943bac3834a4754"

  bottle do
    cellar :any_skip_relocation
    sha256 "014f6beb6e0c389dd4f1b5c9239aceb9f3206e49ceb923d9fa4ebbf86c1f6828" => :catalina
    sha256 "da09746b2475fe5cc05bf7a4808e7b099788a1c733fa6828bb401b06a8f6d56f" => :mojave
    sha256 "92fc3b582c7a8eabeda3e21c204ab41d25219902f51fb7b07e7b2bf788aa39c5" => :high_sierra
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
