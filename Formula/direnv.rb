class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.23.1.tar.gz"
  sha256 "12e01b1df182541654a39c8d631140cf528bfdca6c492545c7e6455748503efa"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc10d8fad64eb6d5f9a0eee257c77c7d812a0a6ea6d53439e001bf023ac1bf1" => :catalina
    sha256 "1307aa1a9a14aa8e4b04abc444d2d36c199c4ff8466d2ef3fba115b61e12ef21" => :mojave
    sha256 "d7cc71241d1e4656598051536dfb30f0d2ef18bf9134e3e899ff3ada3888cd6a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
