class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/v0.6.tar.gz"
  sha256 "714d94473622d756bfe7d70ad6340db3de7cc48f4f356a060e3cb48900c6da01"
  license "LGPL-3.0"
  head "https://github.com/jtsiomb/libdrawtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "62aeef081e3a86502eb7b867f8cd2e44dd4f54ad795183c6a8e6abcda00367e2"
    sha256 cellar: :any, arm64_monterey: "0159f6a1ff8d4337e94df6fd14c7746906e2cc813b6557bf5792bf609c9f9262"
    sha256 cellar: :any, arm64_big_sur:  "7383b095117bbcb658bb4563a709509bc01b4a3e747cf74c394fadb39a677300"
    sha256 cellar: :any, ventura:        "b7aacf82e9f288e7c0b2c61853b062a260859be357ddc1f235dcfad6def2ff0e"
    sha256 cellar: :any, monterey:       "9122e9b931f85762e6cce0cb0041d8e1482eb89de2e1d42a1f7523bbcd9bb5fa"
    sha256 cellar: :any, big_sur:        "30bb9dd29ed877e48308f66be15ef43b2816e9a38b346a2e04b280ab64e677c9"
    sha256 cellar: :any, catalina:       "e6aea4db0e3298e04dfbb215bcedcc4302d76965f82b4dfc921636dbc24ff939"
    sha256 cellar: :any, mojave:         "0c63e8d53c61bcda8452501c584b2f06919054f4e447fa9ce8c929b0bee50d24"
    sha256 cellar: :any, high_sierra:    "a4169631c0ac82995409931836ea16664618d37650337e994bfea7121a386791"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tools/font2glyphmap"
    system "make", "-C", "tools/font2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    ext = (MacOS.version >= :high_sierra) ? "otf" : "ttf"
    cp "/System/Library/Fonts/LastResort.#{ext}", testpath
    system bin/"font2glyphmap", "LastResort.#{ext}"
    bytes = File.read("LastResort_s12.glyphmap").bytes.to_a[0..12]
    assert_equal [80, 53, 10, 53, 49, 50, 32, 53, 49, 50, 10, 35, 32], bytes
  end
end
