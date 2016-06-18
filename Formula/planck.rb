class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.15.tar.gz"
  sha256 "2a346dce8a9ba425311a2e88a439263d1015c23e1c74bad2a7341df5befeeab4"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20604286366be1064717882b2695b3d8eb1f1c08adddd7a0da8801c514d0d98f" => :el_capitan
    sha256 "3af23c0d5b5d56de59add578b27084cd748b655b626ac843f6d82ee9877b9c29" => :yosemite
    sha256 "7e2b80e0c2ce8269c6614209fe796b2286c217fc31a560b3491680ba655a490b" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
