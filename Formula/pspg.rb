class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.7.tar.gz"
  sha256 "d10f93f0a6dd3a1b8afc7cd9927fc8cb11053f5f04152e4896c7e2aedc9f3501"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "dcb8b0b63d662e4a4ac5b06738395887d93e61c021a01e3d3969a3e98214a9c0" => :catalina
    sha256 "758d4e6d1c83344a5362097dc4eb8fa44cb61f7c64e57f00f3540742db76e253" => :mojave
    sha256 "0ee7ef85665c403ae915fc68004e01c9491cbbbc4b0b71fee6049cf42dcc3b2b" => :high_sierra
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
