class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.5.0.tar.gz"
  sha256 "6ef4bdb77f5a4bdabe708e407bb181b41edcb1f83b3354f6aa80a0877902e634"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ed1586bed5c43faac51e1fb4ab41f1210e4c5abf76a39983847dfea696dd080d"
    sha256 cellar: :any, big_sur:       "d62f356909811e0389681191e176713fda96673d14cfc455b42ff260bee9c99b"
    sha256 cellar: :any, catalina:      "c7792e451f55dfa307019a4761121c8f775aedf0eedeb0c3918a5bde6fd6d945"
    sha256 cellar: :any, mojave:        "ba10fff8f95922d008bae385ee0f13e524ab53ed6c76f4a2796d3f6c436f9a58"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
