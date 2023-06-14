class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.7.tar.gz"
  sha256 "2f31ab6dbcd879ad1f6a804d2026296aae830db7a6f4577fdb2a4f18fc89ee8e"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e14767100a7ffe68aa9be4877c04ab680544d1ea2ecdba5f5d5392d2f865458"
    sha256 cellar: :any,                 arm64_monterey: "6edb3f9ecbff490e526fee8bddd20e801f61319a06e38ff216a3bdc8a1d3277b"
    sha256 cellar: :any,                 arm64_big_sur:  "622b30056af431dd47671a7de224e41f578ca09a6f871d270baa5e8e5ac517ab"
    sha256 cellar: :any,                 ventura:        "c1599bf3ec9a0f4683de091b1627651ad592539588ec544926d413399239a555"
    sha256 cellar: :any,                 monterey:       "673f2ef1484f869a519457a7e838d954e8f8a52a5f3673d77d564d1b951542c7"
    sha256 cellar: :any,                 big_sur:        "4d01920bb31f805c66fbfeacf7fe81266ca0c0dada65ed0f9da8c66cd3c2dcd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d99cbe6d593d47904512c18ba82c7de3b32568409b8fe1e9745ed518b09be31"
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
