class Dvanalyzer < Formula
  desc "Quality control tool for examining tape-to-file DV streams"
  homepage "https://mediaarea.net/DVAnalyzer"
  url "https://mediaarea.net/download/binary/dvanalyzer/1.4.2/DVAnalyzer_CLI_1.4.2_GNU_FromSource.tar.bz2"
  version "1.4.2"
  sha256 "d2f3fdd98574f7db648708e1e46b0e2fa5f9e6e12ca14d2dfaa77c13c165914c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d688b087bb74bacc39b805a35b7db02c1291502003eb4904ef5ddbf3063b7c1e" => :mojave
    sha256 "59667b7174026e959f123ebbf8f8e30559dabb70814565f8bec8316c4b9c02b1" => :high_sierra
    sha256 "fb066074dde3b6e94ba30bf37bc85c2e17ef30a7e2b8f874b1a09f3aca2275f7" => :sierra
    sha256 "0e138c105a1f4604dbb4b7c911e83c660f2078cb24af6ba0ba12564a6e93d9c0" => :el_capitan
  end

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--enable-static",
              "--disable-shared"]
      system "./configure", *args
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--enable-static",
              "--disable-shared"]
      system "./configure", *args
      system "make"
    end

    cd "AVPS_DV_Analyzer/Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--enable-staticlibs", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/dvanalyzer --Header", test_fixtures("test.mp3"))
  end
end
