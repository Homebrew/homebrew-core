class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://code.google.com/archive/p/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69df72fe5723c21da07de2aba455a85c72f3a6b653759b523b6a18eaa2e5b51a"
    sha256 cellar: :any,                 arm64_big_sur:  "f1f10acf0972b437479caeaa6e39cf7171d08b30f9ff61419d44fb49b980529c"
    sha256 cellar: :any,                 monterey:       "bc9e506e7ec136da9188ba7ca5f6410b809ac5fdee23cc8526936ec4717c7d20"
    sha256 cellar: :any,                 big_sur:        "cb5925b52641c27251a29e6f5e3cb81b1f076fad26b9c51872c84e771d81f431"
    sha256 cellar: :any,                 catalina:       "214615ae51f807fb4a2990c337545be6376b74741467e91faaff57fb49008ea0"
    sha256 cellar: :any,                 mojave:         "3a41379223936c7802a6df61454f70cb14fb6df6ae43e46d32fea87b1194c11b"
    sha256 cellar: :any,                 high_sierra:    "8e519465f17eadf1db20439176d6d4c120572ca700e3c6d33706df73788f88f7"
    sha256 cellar: :any,                 sierra:         "89f6b5b9085f13f38bacdff51c0082dc17ec992bc8c5366ebfd38542d91d5703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42513283d3c7b3f42678cc887b73446cc2b216bda5feb2c1a8d1ab0b47d352e8"
  end

  depends_on "berkeley-db"
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
