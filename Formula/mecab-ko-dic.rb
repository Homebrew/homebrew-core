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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9149e5ec1b85940657df3ed931d6ddbc83ea1a1e68767b9d27138c5d4ba451c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e39a270ea5fbb5424d0ca358acafc2f08b9232d878eded2789f990f4065aba7"
    sha256 cellar: :any_skip_relocation, monterey:       "e9149e5ec1b85940657df3ed931d6ddbc83ea1a1e68767b9d27138c5d4ba451c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab72fcbb7b1e0bc1ec8667a2d183ad5beab66279d27486ef1ae241d4114fddd1"
    sha256 cellar: :any_skip_relocation, catalina:       "02f67f9bd82e7310074c4c47097bcb4244c79211af9736db8fa73861dbbb820d"
    sha256 cellar: :any_skip_relocation, mojave:         "8d9c37045d060855f558ef8706cee66e918e553ff5c8893811e5cf78767893cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fda9a5da9f32090ef09eca7a8f5098b686079573483b4eb401b7e80db266552"
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
