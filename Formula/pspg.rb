class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.4.tar.gz"
  sha256 "c7bec2a4640f6255b32c698c1c6d9e3e868585137016f35a1a5bc7c25dcd67b5"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f40b2ce40d1af3760f342204da6ae9276600a627fbbec96ed92b78cbd2c6de27"
    sha256 cellar: :any,                 arm64_monterey: "5ae3a298074cb82349c83d944b41f7bb7740d3111cba07b77c595c62eb2c8300"
    sha256 cellar: :any,                 arm64_big_sur:  "cdda3db292a3f2e638edfe2c782c9a632e2becd8104a8b84a87c8be7bc12fc5c"
    sha256 cellar: :any,                 ventura:        "0131b6666b2f4e589fb049b1b8541782001bdc9d7c678fbc3972cc56a2b7b4a5"
    sha256 cellar: :any,                 monterey:       "e9ef00f698b51de89f9409c744853d25e82893491e17a8dc9de77daa399ba64d"
    sha256 cellar: :any,                 big_sur:        "dda6dcdeb8758ed8f098adf6e6086b251e9212221eb7a1f1bf0df5c25eea6fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821c9609fb39b08f8c0f7bc806299439b5b7c3a38bd20789d20cf69189e7d959"
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
