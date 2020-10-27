class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.22.tar.gz"
  sha256 "337a4d040717c38063dbec313e816de71ef6bbea2d5d8b2b609b0f4016aee4dc"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6bcc551ab5a7f4da895483e648186db77ed80a8d6f446a79bc62fa0e9bba8ab" => :catalina
    sha256 "be4e928b3b2e02e80797bc2526625b91f368b234d1e8f8e1801eb9bd24be86da" => :mojave
    sha256 "1b6d05812ade070433b47ebfb332db7859c23eb60636dcc70f65cca6ad04fa04" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
