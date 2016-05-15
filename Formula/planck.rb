class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.12.tar.gz"
  sha256 "f4cb3d4a7b5232715d0521614c189b762e262ddd94617a501c5c130570dc9fb5"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "736294f7feca9b2fde6569e896bdc5b702d0ee74fb7ae5e3a447a333ec096e6f" => :el_capitan
    sha256 "8d9bf3c8d482e81dc67333f2cc8b223a92e7ef35b040b08f951315616a961ea6" => :yosemite
    sha256 "d119087ea5bb9fe7d2775ace2f7f3367209032e1cec1fd88ea1103eb03b2c6de" => :mavericks
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
