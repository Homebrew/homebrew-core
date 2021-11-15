class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  license "Apache-2.0"
  head "https://github.com/agl/jbig2enc.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4bff64113b56cc1d6ded8508bf89159bff934f6bc9e3c6165e2be0c8091cec4c"
    sha256 cellar: :any,                 arm64_big_sur:  "a9971ddbeaf06085f531d9fb58f823360e73561f8703111d3c8ed0340413281a"
    sha256 cellar: :any,                 monterey:       "ff6d3f009b5e9f5283ede3c8c29e844e14a829c0af7b63a7291013c2acd7b58d"
    sha256 cellar: :any,                 big_sur:        "7fa06f2fcbf711d175510a4161ca495bb5ab41cee3052090a650cc9053008ff1"
    sha256 cellar: :any,                 catalina:       "1c24750a1e84a128012a71d0cc47812c29c32136b31dc9c8a15d71d124701c90"
    sha256 cellar: :any,                 mojave:         "62cbf2c1eab2eb5cfe0060887f96d8408fb05a4214580bef8da8a593962b436d"
    sha256 cellar: :any,                 high_sierra:    "7431e5b6cf8354ab27bbb7710b2133eb3d381f3c6a30b7143332fba5e7fe82f7"
    sha256 cellar: :any,                 sierra:         "53d757dc93193756cc90f94a6ca2f4bad2b77610e5b93d5d74f95899019771be"
    sha256 cellar: :any,                 el_capitan:     "f903109f6f2da89af11e576c8776f10e16eadb71c0a60edb9f35157b965edd98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa14b835f1ea7ce9ea69e1b08d7b7ea57a1ae9d8a32e94a1f7c57c73ec15f8b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "leptonica"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
