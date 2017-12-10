class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20171209.tgz"
  sha256 "20139442119e2eff5c35236e8e5e313c901539008d9cccf8c8ab3851b41267e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "55ca70e0f0e409e4ce74fb52fced006a43a2201ed635f90513a62b52dd8381ac" => :high_sierra
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
