class OpenJtalk < Formula
  desc "Japanese text-to-speech system"
  homepage "http://open-jtalk.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.10/open_jtalk-1.10.tar.gz"
  sha256 "5b77ee729e546ca6a22d0b08cda0923fb4225fa782b26c2511b66cc644c14b7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5e7baf1cc05dbb7422c3bc9e1e85823a213af596d7c366a8d7540c4317b78d9" => :sierra
    sha256 "ef859b7fcf09aa4292afce14245e7774f59cf3820f83adc2a219816da07fff55" => :el_capitan
    sha256 "0368c90dde146fd59eda38945655cd7c1f98339b00e0c244327fd31fa2641929" => :yosemite
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
    url "https://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.6/MMDAgent_Example-1.6.zip"
    sha256 "2640ede5831a83e19f9cd8dabca9ad07ef05c50af06c6bc8cb3adfb5e5d4f639"
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
