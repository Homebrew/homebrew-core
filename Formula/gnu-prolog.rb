class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  # Normal download page is from the http://www.gprolog.org/, however in October 2020
  # a slightly updated "1.4.5" version was posted there which broke the sha256 sum
  # In the next release we can go back to using this as our official source, but
  # for now download from GNU which still has the original 1.4.5 available:
  url "https://ftp.gnu.org/gnu/gprolog/gprolog-1.4.5.tar.gz"
  sha256 "bfdcf00e051e0628b4f9af9d6638d4fde6ad793401e58a5619d1cc6105618c7c"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?gprolog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e3825d38dac91ef3dbb9d7b67a6e3352dcc27fb1f897332ba39e5a0b97caad25" => :big_sur
    sha256 "25b07a365e6907466222e64d10458a9006830b3061698eaf6af101f3355d43f9" => :catalina
    sha256 "76ed18b57bf7719b1212adc6fd323b184a9ed496c0ebc7f588ee8e172e887696" => :mojave
  end

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match /Hello World!/, shell_output("./test")
  end
end
