class F3 < Formula
  desc "Test various flash cards"
  homepage "https://fight-flash-fraud.readthedocs.io/en/latest/"
  url "https://github.com/AltraMayor/f3/archive/v8.0.tar.gz"
  sha256 "fb5e0f3b0e0b0bff2089a4ea6af53278804dfe0b87992499131445732e311ab4"
  license "GPL-3.0-only"
  head "https://github.com/AltraMayor/f3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed94f2c50af59a629db9f0662729da93afd6e1ecbf0169c84eedbc5a4533e753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2b9129b2048339b1087ae700292d8d323cfa0f15cbc003c05fd30e7b5e051f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd2510a756c154a088d7b1b10c532a1cd85f4699f52dabb09a340dca20a79d04"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0a54585760470cf81909b26e5a1f21dda6a5e262845a727d8a6c4a952f76d2"
    sha256 cellar: :any_skip_relocation, monterey:       "c4562c2607b59802e798e69a28f3c455f056304b8f731b097b0ac6d586d02b41"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecef018e922b79da5bed5e91df0e8798c9240d527af23b6d5a78c65fed0f4e99"
    sha256 cellar: :any_skip_relocation, catalina:       "198f9b2d578a294fb61e2b9203cc1285c9c0a2fa6048fb1e34130f7d8a2039ff"
    sha256 cellar: :any_skip_relocation, mojave:         "70d5966a5afb44fe91225d81f54adf80cd7b254ac9253423234d4c99d4a2435d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "55da39f3758797df44426b7744542b4322ddc84b20fc7a5664e2da672cef0d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd928c111d89adb6098858ab9a2f4332b1aa86004d3cc7b424312978638e7e9"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    args = []
    args << "ARGP=#{Formula["argp-standalone"].opt_prefix}" if OS.mac?
    system "make", "all", *args
    bin.install %w[f3read f3write]
    man1.install "f3read.1"
    man1.install_symlink "f3read.1" => "f3write.1"
  end

  test do
    system "#{bin}/f3read", testpath
  end
end
