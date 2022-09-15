class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.7.tar.gz"
  sha256 "d9bb4e80bd6ddea2be0b835e6bd66bca7567a5f59641e31cfde4dc194fee7e9e"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "33cb4d73af59a6dce68609537461825d7f1197ec4f870994c65849c284bd47bb"
    sha256 cellar: :any,                 arm64_big_sur:  "ad3db81f3051cde0af4ae8b95af2cc4ba8851a2dbaeb9992f6ef0aaaaeb5d483"
    sha256 cellar: :any,                 monterey:       "89b2c598bb55189f1d27f0d8b87c371c2094d4ca5c146877c7abcd5134a9782b"
    sha256 cellar: :any,                 big_sur:        "af26621e02aaac9cb9c4826cb3b9d4dc4037970b9ccb125520380277f3e9caf4"
    sha256 cellar: :any,                 catalina:       "aba9f41bccfcfc8ac187f4ad0a7b31f51cd515272cbad38e0c34003fa5e5d403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15d19a5187bf20662771c1926461a39b992c04f692c38719d1f50e0c15c8ea2"
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
