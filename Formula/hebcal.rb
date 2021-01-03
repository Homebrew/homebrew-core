class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.24.tar.gz"
  sha256 "64e885d45b2006539af3135dacdb3b540092483bf0380e1b0e5bea224ca19889"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "50bb891ba8767cc9246e901ffeda0f40760c729b2133921e449ffdaa0d919743" => :big_sur
    sha256 "0453378bad2e456d04fa92372e092c605a939deecb32113c046dab60ebc48a89" => :arm64_big_sur
    sha256 "31594dfcc89ab5391855562e5bb9eaa3ed73c6d8b3a04a4b63128e8d98bd147a" => :catalina
    sha256 "693f582fb6b18ce06243e9944609e0e9f41c2fb3637363cdf94ed7c419c5d53b" => :mojave
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
