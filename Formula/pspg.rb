class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.8.tar.gz"
  sha256 "bc25e517784f08840796188d1fb8e908ed522d0809c0ca176eae07363bd5281b"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e09ad19e338456249f1d2ff3862fbb059c7704609382686edb8d4b781cf1187"
    sha256 cellar: :any,                 arm64_big_sur:  "37c0075d494f3fc6f11c27e22862efaf5215ecb423a6576e52e52fbd96cbaab9"
    sha256 cellar: :any,                 monterey:       "ecb371c2c95df0171e46b857dbb355e54a1cd9e0be8e1513c2583b23a13e3ad1"
    sha256 cellar: :any,                 big_sur:        "8d084ec1ee67984c8ea873ec94440a84cc06dd2b442f50bf7afb14f9029ede93"
    sha256 cellar: :any,                 catalina:       "d58be0e4dcdd8a464170920889472cd9c258fb787593840aacf38a933ca3f571"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39c97a8801bac725baf6d5321e205bda40ac696ea95b11bcc0f5376803faef4"
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
