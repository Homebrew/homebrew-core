class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "http://invisible-island.net/dialog/"
  url "ftp://invisible-island.net/dialog/dialog-1.3-20170509.tgz"
  mirror "https://fossies.org/linux/misc/dialog-1.3-20170509.tgz"
  sha256 "2ff1ba74c632b9d13a0d0d2c942295dd4e8909694eeeded7908a467d0bcd4756"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae701f5888a92c5471a133d3af23ec16de80f484a613f665c22c72bd9dd3e8cb" => :sierra
    sha256 "c7f6b3631580d468acdea09309b9d3073c4ab6bb474f3479a679c75c93215f14" => :el_capitan
    sha256 "d7a24282dfa9cc3a5a6b45aef751291079816f3560ec1ec3f1c1bffe787c374a" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
