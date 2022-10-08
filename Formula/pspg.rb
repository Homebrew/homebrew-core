class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.8.tar.gz"
  sha256 "bc25e517784f08840796188d1fb8e908ed522d0809c0ca176eae07363bd5281b"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e34cb95261948d0194e1225004f7ed4339b62de9b9c94767255e2fee7172bf6e"
    sha256 cellar: :any,                 arm64_big_sur:  "831b6556c33d1711b318a595b9af8c222bc458bb6b4c4ed82a291b957efc3579"
    sha256 cellar: :any,                 monterey:       "03c9bb1e5615320dce4d6bb3255a3f4c05c611cdbf78dae423bbfbdcaff2a527"
    sha256 cellar: :any,                 big_sur:        "02823e8a9f42c0a96be99417da6993ec1f416e7af1f156e90f8a065887b93a86"
    sha256 cellar: :any,                 catalina:       "0f1f6ffef52c2277c92c93a6fcf50952740ac5933015a8e585b70fba177e6f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "727df27c79e14a8547bb2cccb3af376747e69d28df213339692a0605df526ac6"
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
