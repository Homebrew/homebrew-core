class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "https://ftpmirror.gnu.org/gcal/gcal-4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-4.tar.xz"
  sha256 "59c5c876b12ec70649d90e2ce76afbe2f4ed93503d49ec39e5c575b3aef8ff6e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ec62a4a5840e34f059baa4c7644a3ca23466ba7823ba60426cf804e1e016d318" => :sierra
    sha256 "fbe42347ddde707d847d215350a19d2a0356e54614b289cde17b8ecb7f8156c4" => :el_capitan
    sha256 "dab7e957c76dd7ff92202fcc25da0f78fd35639edaa9a3cb84442a97d2a9a3a8" => :yosemite
    sha256 "5bbba3a4824c1d11dcea9dc80912333e904c84e6e2b18f5d0abe6377eb5c0c27" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    system "make", "-C", "doc/en", "html"
    doc.install "doc/en/gcal.html"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
