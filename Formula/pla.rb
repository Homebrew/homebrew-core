class Pla < Formula
  desc "Tool for building Gantt charts in PNG, EPS, PDF or SVG format"
  homepage "https://www.arpalert.org/pla.html"
  url "https://www.arpalert.org/src/pla-1.2.tar.gz"
  sha256 "c2f1ce50b04032abf7f88ac07648ea40bed2443e86e9f28f104d341965f52b9c"

  bottle do
    cellar :any
    sha256 "a93517a26dab0bab4ab32aff81c7af3b7545ae1be265ce15caacc3772cd6d485" => :catalina
    sha256 "9d5e86767de6c9a2ac741e9edd32d053da5fde96563446a63d1b0475f4da595a" => :mojave
    sha256 "af3163cf8322d872694753f3d3352384fb9c8ce923c66f7be82f50bdbbe734bc" => :high_sierra
    sha256 "c6edebbefcf192ea4bcad704ca5b4c27157f77b4a47e3a993ac2a61e7165c13c" => :sierra
    sha256 "3fd0d11d1bdfa24e93bf94cb854e28382307c291b25994c82a2a8c1a64ce5072" => :el_capitan
    sha256 "308920e8bf8642826cd973eaa63e22f0fc3dec43a0152485d358ba575638291f" => :yosemite
    sha256 "df4b500589672dc1c415866b7da4c678621858f48cbac2cab5765c2b4fb1857d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"

  def install
    system "make"
    bin.install "pla"
  end

  test do
    (testpath/"test.pla").write <<~EOS
      [4] REF0 Install des serveurs
        color #8cb6ce
        child 1
        child 2
        child 3

        [1] REF0 Install 1
          start 2010-04-08 01
          duration 24
          color #8cb6ce
          dep 2
          dep 6
    EOS
    system "#{bin}/pla", "-i", "#{testpath}/test.pla", "-o test"
  end
end
