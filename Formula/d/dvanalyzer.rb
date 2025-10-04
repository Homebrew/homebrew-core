class Dvanalyzer < Formula
  desc "Quality control tool for examining tape-to-file DV streams"
  homepage "https://mediaarea.net/DVAnalyzer"
  url "https://mediaarea.net/download/binary/dvanalyzer/1.4.2/DVAnalyzer_CLI_1.4.2_GNU_FromSource.tar.bz2"
  sha256 "d2f3fdd98574f7db648708e1e46b0e2fa5f9e6e12ca14d2dfaa77c13c165914c"
  license all_of: ["BSD-2-Clause", "GPL-3.0-or-later", "Zlib"]

  livecheck do
    url "https://mediaarea.net/DVAnalyzer/Download/Source"
    regex(/href=.*?dvanalyzer[._-]?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e1d43037409673d2095be07916360762989d3ce9607c56280f498e881d1af521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a3b6fd3f4af125d1e85f299d7c7c30475a429a7f5d627426e77f5eeddc3d27b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd458167da95107a9a0e3c31bf676a44d1fa64789f92d9ed2c7aeeea8cdef306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499a358163cb7361ca01a66f258e5544f7facf0d6394d3608fc06c2d42aedf71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5505972404a52e27d0b958ca01f6d0b4776b9698e158edb3408a08f57b9627"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c3394dede8aedd03611a44ab7f0e9c0cf65de9343eea185575234571da63b76"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb85daa7321c24dd1467de0ba27fa74de80c65ba80495c277d2ee1a2d302061d"
    sha256 cellar: :any_skip_relocation, ventura:        "056655cdb3b17dd0ea0aceede196aa68533a91a361ea5db0e532f92715d1a767"
    sha256 cellar: :any_skip_relocation, monterey:       "3b6827ba646ecac89cfb7437785df9586bfe1df4a4129b418fb7fb58ba2d6078"
    sha256 cellar: :any_skip_relocation, big_sur:        "c82268f8073ce66058329a7f3e17a8dffba0d811f82c1eb33a6a45144693bf17"
    sha256 cellar: :any_skip_relocation, catalina:       "1e9397fde0dde748e89f06dabbcabce109fef89914a436b71b754bd32f179e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e5d73bfd1ef1e77613f71f59670c174b49b2032abbca48dfed5da2835f07b169"
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
    test_mp3 = test_fixtures("test.mp3")
    output = shell_output("#{bin}/dvanalyzer --Header #{test_mp3}")
    assert_match test_mp3.to_s, output

    assert_match version.to_s, shell_output("#{bin}/dvanalyzer --Version")
  end
end
