class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/2.5.3.tar.gz"
  sha256 "1a85d2a60959122f48ae6a38d8666a3a47f9d14f0bec95f355cd225f5ecaaf50"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "efe13b563bb04d1ea0245904a29eb0ffecef99d520b6b9a07f6ecca09b4a6bf1" => :catalina
    sha256 "ee50a412369f97e19ea59dba3315e1159bc91c06bb13bc36c79588f13032b19e" => :mojave
    sha256 "978a2c0600cf23ab33fa128da6870d8df73949f1c57549ee33cde36b8380f196" => :high_sierra
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
