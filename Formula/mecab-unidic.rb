class MecabUnidic < Formula
  desc "Morphological analyzer for MeCab"
  homepage "https://osdn.net/projects/unidic/"
  # Canonical: https://osdn.net/dl/unidic/unidic-mecab-2.1.2_src.zip
  url "https://dotsrc.dl.osdn.net/osdn/unidic/58338/unidic-mecab-2.1.2_src.zip"
  sha256 "6cce98269214ce7de6159f61a25ffc5b436375c098cc86d6aa98c0605cbf90d4"

  livecheck do
    url "https://osdn.net/projects/unidic/releases/"
    regex(%r{value=.*?/rel/unidic/unidic-mecab/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2268e16ea3e293eface41c4f3693340dd784c15963ddc3693f3d48586e323d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b33a3f250d1429ad2dd434b802eaf2f7e4b98c3de7244e60edcae1bfdbc5713"
    sha256 cellar: :any_skip_relocation, catalina:      "f1419955f289e83845d58e3c9932952e2dac7984edad0d85d083c7f281a6558c"
    sha256 cellar: :any_skip_relocation, mojave:        "15b1cd2eb3cc04747ee04b71aaaf7b99323e58d5ebdb4e79b4c9c3d36e656f1d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9062af2305cf97efe00b42bda1b89253b487cea1ef3675e6f4c187dea1e37033"
    sha256 cellar: :any_skip_relocation, sierra:        "083c740c7c309410266eb793755477b6d37da6f6c85dddbb62e31b27dcbae135"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9ece990d89f8949c82003296bd256ebafddaf5d9caf03a63ea692f2009d52783"
    sha256 cellar: :any_skip_relocation, yosemite:      "f81fd4ff64eb6b7731fd4b818b17398b1eaea3d12d533a7340b9b12aa2331c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879c531b56d96abefea1809837e3309816fd442381766dea3675424ba7c6772e"
    sha256 cellar: :any_skip_relocation, all:           "879c531b56d96abefea1809837e3309816fd442381766dea3675424ba7c6772e"
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-dicdir=#{lib}/mecab/dic/unidic"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-unidic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/unidic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
