class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.1.1.tar.gz"
  sha256 "91fefbf18a07223e66db4f09ea01b4b14829945ce318c0bf39b6efad4afbd2db"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "6dbc8c9cc3b87569f4e3a601f17097209a0676d60b026cd9060a24d8851d1117" => :high_sierra
    sha256 "470d3cd08eef06e253c34b0a592bf00906320d9a8934a12e2b62ed5c6506bac2" => :sierra
    sha256 "ad347b5528c6e3cbc87adb65ece4f12eb62eb76ae214bfd85e969284d49e0103" => :el_capitan
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
