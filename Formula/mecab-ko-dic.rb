class MecabKoDic < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-2.1.1-20180720.tar.gz"
  sha256 "fd62d3d6d8fa85145528065fabad4d7cb20f6b2201e71be4081a4e9701a5b330"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/href=.*?mecab-ko-dic[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "095bb6b6936fb71be5ec8247aaae525cd8f506896b4e9940a6dbba0a262a8ad4" => :big_sur
    sha256 "5c3d0709fbddf74067362680d226f5ecf170ee903532f8d34399b731d188a13d" => :catalina
    sha256 "ce481dc10cc5b42ba1aeb863e3fdec5edd69dbf80eb3636a30adbf088c4d0508" => :mojave
    sha256 "6e7d71dc788c552a2d2e345ff67aad4a6f5c9078eb776056ccf96dd599c63f52" => :high_sierra
    sha256 "68715d65e93b56fa18f70579b515b4e69128777e89c069da9af9ab6dd689bc9e" => :sierra
    sha256 "51c5a40a0aad7906cbd83265fbecbc4de3a4f116abceebf9fdb02d17c75f5f69" => :el_capitan
    sha256 "92be006bcc8552fdaddf82d21b9f8f528af010128febc721a5a5ba262eca99ce" => :yosemite
    sha256 "0c958bf826cd358431f144dfb3d2d3da08c67cda59efe1d2998b54a401678515" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "mecab-ko"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/mecab-ko-dic"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-ko-dic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/mecab-ko-dic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "화학 이외의 것\n", 0)
  end
end
