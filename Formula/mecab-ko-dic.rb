class MecabKoDic < Formula
  desc "See mecab"
  homepage "https://bitbucket.org/eunjeon/mecab-ko-dic"
  url "https://bitbucket.org/eunjeon/mecab-ko-dic/downloads/mecab-ko-dic-1.6.1-20140814.tar.gz"
  sha256 "251fb141f2e96d34ea62f557c146ab0615dea67502cce8811d408309f182cfb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce481dc10cc5b42ba1aeb863e3fdec5edd69dbf80eb3636a30adbf088c4d0508" => :mojave
    sha256 "6e7d71dc788c552a2d2e345ff67aad4a6f5c9078eb776056ccf96dd599c63f52" => :high_sierra
    sha256 "68715d65e93b56fa18f70579b515b4e69128777e89c069da9af9ab6dd689bc9e" => :sierra
    sha256 "51c5a40a0aad7906cbd83265fbecbc4de3a4f116abceebf9fdb02d17c75f5f69" => :el_capitan
    sha256 "92be006bcc8552fdaddf82d21b9f8f528af010128febc721a5a5ba262eca99ce" => :yosemite
    sha256 "0c958bf826cd358431f144dfb3d2d3da08c67cda59efe1d2998b54a401678515" => :mavericks
    sha256 "b932747391e494b10a0fd8cd6002eb857f7a4ccb8e0ea2ea2a3a7b675bf6c237" => :mountain_lion
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
