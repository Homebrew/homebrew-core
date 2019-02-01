class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.19.1.tar.gz"
  sha256 "0963dae84eed89cf0aaa1679830d0546d51c4952608912137c67e51c852a4011"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aecde08a0e127e8878b884556c0b77cca7e561f4e745da4b9ad6ecc43fcbcae" => :mojave
    sha256 "7f8fe01060b644545c377af5d2f0e69605227f53362a1587d924ac29ece11e78" => :high_sierra
    sha256 "ad6868e34c6a2d82157ceb8a7d8876bac8a5c23b0e40dd5584d0b028eb229b45" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/direnv/direnv").install buildpath.children
    cd "src/github.com/direnv/direnv" do
      system "make", "install", "DESTDIR=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"direnv", "status"
  end
end
