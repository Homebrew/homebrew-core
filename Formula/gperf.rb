class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf"
  url "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
  sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cbaa18692ac53ce98a754d46e07e89d6dddca4bef3bbb312e762abf5a30093d" => :sierra
    sha256 "27f661ef9546ff113279654e92c08bb8d8ab837f7dc8b308c1a2beeafdcebc76" => :el_capitan
    sha256 "263440c302dddec69c2140e8df2e4c00a76b76137243e712e8e8756140e0eaf5" => :yosemite
  end

  keg_only :provided_until_xcode43

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output("#{bin}/gperf", "homebrew\nfoobar\ntest\n")
  end
end
