class OpenJtalk < Formula
  desc "Japanese text-to-speech system"
  homepage "https://open-jtalk.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.10/open_jtalk-1.10.tar.gz"
  sha256 "5b77ee729e546ca6a22d0b08cda0923fb4225fa782b26c2511b66cc644c14b7d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f71eb4d92a5bba718ac8c7e7a16f54c65651819db3b17a99d5701cafa12e596c" => :mojave
    sha256 "6acdf89723494c61c4118b157b283b2eb9579846b34b6168908132750a4f99c8" => :high_sierra
    sha256 "a472664a3ab3edb6fe9198aeecfc8c4881cf62298c09eec9dce78ad04a591f5c" => :sierra
    sha256 "1f688549f09842e4513ee93386e747fc5b819239a808c0b6de08e74f41619f37" => :el_capitan
    sha256 "ebcd63c3814851c22a8e536791a8ece8fd7b77a9dd77856b0aec705eab82e0b0" => :yosemite
  end

  resource "hts_engine API" do
    url "https://downloads.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.10/hts_engine_API-1.10.tar.gz"
    sha256 "e2132be5860d8fb4a460be766454cfd7c3e21cf67b509c48e1804feab14968f7"
  end

  resource "voice" do
    url "https://downloads.sourceforge.net/project/open-jtalk/HTS%20voice/hts_voice_nitech_jp_atr503_m001-1.05/hts_voice_nitech_jp_atr503_m001-1.05.tar.gz"
    sha256 "2e555c88482267b2931c7dbc7ecc0e3df140d6f68fc913aa4822f336c9e0adfc"
  end

  resource "mei" do
    url "https://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.7/MMDAgent_Example-1.7.zip"
    sha256 "5b560e8c23c5acaf67688e6e25788db2c0bb230aff0635b7c75a82a87c7f6dba"
  end

  def install
    resource("hts_engine API").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end

    system "./configure", "--with-hts-engine-header-path=#{include}",
                          "--with-hts-engine-library-path=#{lib}",
                          "--with-charset=UTF-8",
                          "--prefix=#{prefix}"

    if MacOS.version <= :mavericks
      inreplace "config.status", "-finput-charset=UTF-8 -fexec-charset=UTF-8", ""
      # https://sourceforge.net/p/open-jtalk/mailman/message/33404251/
    end

    system "make", "install"

    resource("voice").stage do
      (prefix/"voice/m100").install Dir["*"]
    end

    resource("mei").stage do
      (prefix/"voice").install "Voice/mei"
    end
  end

  test do
    (testpath/"sample.txt").write "OpenJTalkのインストールが完了しました。"
    system bin/"open_jtalk",
      "-x", "#{prefix}/dic",
      "-m", "#{prefix}/voice/mei/mei_normal.htsvoice",
      "-ow", "out.wav",
      "sample.txt"
  end
end
