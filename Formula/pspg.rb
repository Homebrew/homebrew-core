class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.6.4.tar.gz"
  sha256 "2d2b14a87056ce09625298de22629866c3c14aa55d46ea7ee627a682b9ea804e"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "282603c8a30facf530e56c5ae9afc1a18c6cc967d3d261598e9a1c098a027ce8" => :catalina
    sha256 "6850be58486b6c7884a2445377235fd44d89692b1f18cffcf2f902075b5d9d98" => :mojave
    sha256 "8d57ad89ea8726a897ab60afc6b7e3b09799f388189223dda876266f655999ed" => :high_sierra
  end

  depends_on "libpq"
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
