class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.2.1.tar.gz"
  sha256 "b7a083662ddfeac8a2af118238a67bd58b1ad7bb9b0e81dfa95ccde1fa06677f"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "255423ef53a53fccadb49f1b3ded8370041d564c2d2a95d34b948795d59050f2" => :high_sierra
    sha256 "185b1b4252bd5c7f3d1c5b1c632798eaa05680745b2a361ff6c4b04ab9313d26" => :sierra
    sha256 "91072c88d4d845d60924164de8e6876159973df81331ad6a4e765e6b351d95fa" => :el_capitan
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
