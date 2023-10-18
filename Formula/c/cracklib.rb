class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.11/cracklib-2.9.11.tar.bz2"
  sha256 "ca8b049a3c2d3b2225a1e8d15d613798ebc748e3950388eda2694de507ba6020"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "94fbedda3c69ccc05abb91ba942bf55997f8e2c8ee80d3b9932ae5d3f091b34b"
    sha256 arm64_ventura:  "6a3a072cf106fde02db24ad3024d75795afd6fcd8595a50e569f9eafa0b8f849"
    sha256 arm64_monterey: "366eea9cce24cf4353676bfd54bef63596fd678992b138c81606e6083526f5fe"
    sha256 arm64_big_sur:  "fa8e46c43b097175d54821836f5e41edff34dbad7b3a8f40e581141903111e67"
    sha256 sonoma:         "57dacbc37230ae1921e26a97f165c6da146078e513b1fea347e418dca29ebd0c"
    sha256 ventura:        "f7aed3f2bd1d5ff0c0da5f42e443b239fb126bd3f0ec72db65c581a30fb84bcc"
    sha256 monterey:       "5b2918b1e6b0e356b3c1039498d7ff241f5d339a1a8e685bd63ae64aee4180da"
    sha256 big_sur:        "ed0830783c21bfb87f7c9f3a3775806cc5be421ff34d5e82749ebc3e1c9e8af0"
    sha256 x86_64_linux:   "c0c98e94bf0217fd21363d1543d51c13a86c83c56039e2f7ce128b30bbaed5a2"
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.11/cracklib-words-2.9.11.bz2"
    sha256 "ec25ac4a474588c58d901715512d8902b276542b27b8dd197e9c2ad373739ec4"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
