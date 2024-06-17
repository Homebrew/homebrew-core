class Dvanalyzer < Formula
  desc "Quality control tool for examining tape-to-file DV streams"
  homepage "https://mediaarea.net/DVAnalyzer"
  url "https://mediaarea.net/download/binary/dvanalyzer/1.4.2/DVAnalyzer_CLI_1.4.2_GNU_FromSource.tar.bz2"
  sha256 "d2f3fdd98574f7db648708e1e46b0e2fa5f9e6e12ca14d2dfaa77c13c165914c"

  livecheck do
    url "https://mediaarea.net/DVAnalyzer/Download/Source"
    regex(/href=.*?dvanalyzer[._-]?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd458167da95107a9a0e3c31bf676a44d1fa64789f92d9ed2c7aeeea8cdef306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499a358163cb7361ca01a66f258e5544f7facf0d6394d3608fc06c2d42aedf71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5505972404a52e27d0b958ca01f6d0b4776b9698e158edb3408a08f57b9627"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3394dede8aedd03611a44ab7f0e9c0cf65de9343eea185575234571da63b76"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb85daa7321c24dd1467de0ba27fa74de80c65ba80495c277d2ee1a2d302061d"
    sha256 cellar: :any_skip_relocation, ventura:        "056655cdb3b17dd0ea0aceede196aa68533a91a361ea5db0e532f92715d1a767"
    sha256 cellar: :any_skip_relocation, monterey:       "3b6827ba646ecac89cfb7437785df9586bfe1df4a4129b418fb7fb58ba2d6078"
    sha256 cellar: :any_skip_relocation, big_sur:        "c82268f8073ce66058329a7f3e17a8dffba0d811f82c1eb33a6a45144693bf17"
    sha256 cellar: :any_skip_relocation, catalina:       "1e9397fde0dde748e89f06dabbcabce109fef89914a436b71b754bd32f179e8a"
    sha256 cellar: :any_skip_relocation, mojave:         "d688b087bb74bacc39b805a35b7db02c1291502003eb4904ef5ddbf3063b7c1e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "59667b7174026e959f123ebbf8f8e30559dabb70814565f8bec8316c4b9c02b1"
    sha256 cellar: :any_skip_relocation, sierra:         "fb066074dde3b6e94ba30bf37bc85c2e17ef30a7e2b8f874b1a09f3aca2275f7"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0e138c105a1f4604dbb4b7c911e83c660f2078cb24af6ba0ba12564a6e93d9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "439d718775ff2f2f2ae7f076c4cf120298b116b6a6fb0afdc4236823387948f0"
  end

  uses_from_macos "zlib"

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
      system "./configure", "--disable-debug", "--enable-staticlibs", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/dvanalyzer --Header", test_fixtures("test.mp3"))
  end
end
