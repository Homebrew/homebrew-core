class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.15.tar.gz"
  sha256 "2a346dce8a9ba425311a2e88a439263d1015c23e1c74bad2a7341df5befeeab4"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f1aa944cb723e6fcda5cb40323478123c8e8404b9df8fa086072cf78c58a263" => :el_capitan
    sha256 "0056670adc045465e747882d0ae832cc91aff18eac5645687269cd07dee0e36b" => :yosemite
    sha256 "b03d8a85f59d4ac59b65ad8f68a08a1dfbf36b9d52f29f6037b3ca4ec88a9412" => :mavericks
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
