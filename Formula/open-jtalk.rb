class OpenJtalk < Formula
  desc "Japanese text-to-speech system"
  homepage "https://open-jtalk.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/open-jtalk/Open%20JTalk/open_jtalk-1.11/open_jtalk-1.11.tar.gz"
  sha256 "20fdc6aeb6c757866034abc175820573db43e4284707c866fcd02c8ec18de71f"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6fb63e85e6e7e5b3e6bc4071fe38e9bca7f3f820deb6838a4a6b700529b02c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e84db4a3e1d2a336eb2da7f1060845f35ac1db68be727e524dcbfdb2f785ad"
    sha256 cellar: :any_skip_relocation, monterey:       "6d2bd635abd20f62e50e9d39be4d2b1c50f1bb2a94d87bc2ab396d4f0afba310"
    sha256 cellar: :any_skip_relocation, big_sur:        "b68172f2ccf166ea5e1b46c1908714386cfb24dcafa374a1ab172faa4844cc9a"
    sha256 cellar: :any_skip_relocation, catalina:       "0a251febe3197994355ab780ce02aa45264c7d148b0f1b0dfd1a80a7f7aa9937"
    sha256 cellar: :any_skip_relocation, mojave:         "bed36f972fe3dc3d5f286eff5c1b1605a1bcfae6cc755b7b2aee57fc497f7913"
    sha256 cellar: :any_skip_relocation, high_sierra:    "cd50656bb81db4528b82b844c773440d6cdfec63e545a64002a473da05a7eb18"
    sha256 cellar: :any_skip_relocation, sierra:         "b015d173b77980d0da3a8eedad02fdff95ac919c790917ba9cb197db91207235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09fa6df65a5004730ee6d41ca9580ccd58933ddc33c6b3f64f1ba732ce7f3ce8"
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
    url "https://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.8/MMDAgent_Example-1.8.zip"
    sha256 "f702f2109a07dca103c7b9a5123a25c6dda038f0d7fcc899ff0281d07e873a63"
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
