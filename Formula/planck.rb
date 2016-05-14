class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.11.tar.gz"
  sha256 "61e4105d4df04edeea5ec4e884b749339ba65b1ca6b719e4cf14f94d6042f786"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "736294f7feca9b2fde6569e896bdc5b702d0ee74fb7ae5e3a447a333ec096e6f" => :el_capitan
    sha256 "8d9bf3c8d482e81dc67333f2cc8b223a92e7ef35b040b08f951315616a961ea6" => :yosemite
    sha256 "d119087ea5bb9fe7d2775ace2f7f3367209032e1cec1fd88ea1103eb03b2c6de" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on "maven" => :build
  depends_on :xcode => :build
  depends_on :macos => :lion

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
