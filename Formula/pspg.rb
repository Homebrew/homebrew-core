class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.1.5.tar.gz"
  sha256 "9b78637908129937907f71de00a487c7dc94a4988019232771c7c1654a5edff8"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "7e94d95d5f3b45d8b4173925c4230e606c3879823c2bfd57f2e70e7ff45d9b0b" => :catalina
    sha256 "4f3374a088351b0d3d3628c7777675a4584c44d5bc46c8dbfe89d815591f9541" => :mojave
    sha256 "3d5e75d67e06e05e5393be11fffcc6496004d11d9afd697a34b61b8eca5364e0" => :high_sierra
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
