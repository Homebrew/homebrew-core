class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
    :revision => "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"

  bottle do
    cellar :any
    sha256 "499e9a94e24c8965b9a31902ab2a14a021c780756451b82ac2313c7c86ac5756" => :sierra
    sha256 "2665c0ed4da2eb399314d044699385250ca5db54e6f8c22287222b7877881d22" => :el_capitan
    sha256 "47251f13fa79c98b3c41d45cafade044bded134256f56e6ee1a118f67eb325d8" => :yosemite
  end

  depends_on "wxmac"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
