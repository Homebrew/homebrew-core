class MecabIpadic < Formula
  desc "IPA dictionary compiled for MeCab"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM
  url "https://deb.debian.org/debian/pool/main/m/mecab-ipadic/mecab-ipadic_2.7.0-20070801+main.orig.tar.gz"
  version "2.7.0-20070801"
  sha256 "b62f527d881c504576baed9c6ef6561554658b175ce6ae0096a60307e49e3523"

  # We check the Debian index page because the first-party website uses a Google
  # Drive download URL and doesn't list the version in any other way, so we
  # can't identify the newest version there.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/mecab-ipadic/"
    regex(/href=.*?mecab-ipadic[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)(?:\+main)?\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd42086389a7302de36628435004c2f8de2f55b01f6fd8b5a74529779fc2754a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd2a69bbcbfe6e051278c94e4e19c6bfde63e2a3e525e2c57da0afb37ee5b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd42086389a7302de36628435004c2f8de2f55b01f6fd8b5a74529779fc2754a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fc2878d95314057c5d0f726cc1dacf2ce110c7e84b77806e958970f9b34ccc5"
    sha256 cellar: :any_skip_relocation, catalina:       "90271975d35925136a14f2563e4b5201bed51b5c1fc27249d916676027c1016e"
    sha256 cellar: :any_skip_relocation, mojave:         "30967b4167d34f05c79f185d71a40198fff4067d0cce82aed59383548c898681"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ef5cf167b05fd74457d5c31a46750450e8f80720ebc705766ee10df6ed41a861"
    sha256 cellar: :any_skip_relocation, sierra:         "33f42c18d7347708a56d8846c0bde5c8291b7685ce06b342e96442bca35f6663"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9f0ae0a62141e3b28807349cb7a9560e36770acb869f4a4e7a54ea1a28ef8ba5"
    sha256 cellar: :any_skip_relocation, yosemite:       "55703c812de3e7cff503b9cd1eafa0656b3f17c4885165ce4d8e4d2b2356050e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df2442b2842ff74edaee7ff39d84ac0ee9a4e6eefd931d80eac8c181b04d1b9d"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=utf8
      --with-dicdir=#{lib}/mecab/dic/ipadic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-ipadic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
