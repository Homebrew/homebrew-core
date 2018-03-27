class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.12.6.tar.gz"
  sha256 "44174df56c79dac1f755606a30c35145303512cbab49bb389b2cd639e86132bd"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "fc5df2c511ee36735dad8585311595839f739790fe3cc125b5683f9af6ef2402" => :high_sierra
    sha256 "5f5f7a94575f37ff13ca2860b0f2229d3b7fa13fd28daa300c54c67c443a5c9f" => :sierra
    sha256 "0c8b54dfbfe7367f6d541c29848569f38ab0d56d7ff14ef9a818abe083279ea3" => :el_capitan
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
