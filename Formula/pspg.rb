class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/0.9.2.tar.gz"
  sha256 "c1953f5ea08acc26e6509bee46aee0e19132f7ccde27bc8fd5d5b1a70fbabf87"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "90106c7f56507802a0678c0d978835a1b7b4b2a5bb7a6004488d463f2f8daee7" => :high_sierra
    sha256 "d1e29f14696b0daacd11ff58b80d404068107cf5e5b65734cd28ed8a7581f5b2" => :sierra
    sha256 "b2b6fff8b571781a81222edcb480258e7ae561470a29a6b7e76e1c8324e08a13" => :el_capitan
  end

  depends_on "ncurses"

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
