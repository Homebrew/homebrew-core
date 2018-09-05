class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.2.2.tar.gz"
  sha256 "e305ded645c096f4993960f33b4ef217d60077193fb06b89dd594060cf4c73fd"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "89c02d73dc9a56ac626d892152b897d1e52be4788c857b73c04208d8ca48ab47" => :mojave
    sha256 "e0eb4303b033ffa69fe977126c28643ff3bf61beee66596b86f014e567e9f9de" => :high_sierra
    sha256 "d9cdfe0d7e161a44e939c1a4536d3fad54f25d49e38c4fafb9f448876c6a37fa" => :sierra
    sha256 "eeb5cca908747d61f994a965fe5b5a83de898a8ce3338923c8c2fe54891251ab" => :el_capitan
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
