class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.11.tar.gz"
  sha256 "61e4105d4df04edeea5ec4e884b749339ba65b1ca6b719e4cf14f94d6042f786"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3621f8a980bcc9cc34ed0567418dbdf53d2a64af42337f873fa796440f7dca6" => :el_capitan
    sha256 "0e928b9a6313949a5f2f44e83624a1eab0fe83907159147bf4e1d6344bbd683f" => :yosemite
    sha256 "8c97a1b4cb5b9dc5027daa1f0f296669b068db1314e2d655f4f53d957a0e8b8e" => :mavericks
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
