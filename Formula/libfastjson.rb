class Libfastjson < Formula
  desc "A fast json library for C"
  homepage "https://github.com/rsyslog/libfastjson"
  url "https://github.com/rsyslog/libfastjson/archive/v0.99.6.tar.gz"
  version "0.99.6"
  sha256 "617373e5205c84b5f674354df6ee9cba53ef8a227f0d1aa928666ed8a16d5547"
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  bottle do
    cellar :any
    sha256 "3d9c4f57fa3c9fc660cfbd7ea5776e84ae0afb6d675e40e765f3d837d7e03acd" => :sierra
    sha256 "a17c1a642eec3897196bec92577ba1e5048be866f293f0537fcbf7c8879197f8" => :yosemite
    sha256 "0e3a9ab66624f91740108c0808115b44aeb740e75f6dedb2829128f944e0df37" => :el_capitan
  end

  head do
    url "https://github.com/rsyslog/libfastjson.git"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end
