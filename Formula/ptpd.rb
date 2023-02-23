class Ptpd < Formula
  desc "PTP daemon (PTPd) implementing the Precision Time Protocol (PTP) v2"
  homepage "https://github.com/ptpd/ptpd"
  url "https://github.com/ptpd/ptpd/archive/refs/tags/ptpd-2.3.1.tar.gz"
  sha256 "267ad61d09d97069acec5d4878dceda20d0ddbebd27557d80230847848cee6c2"
  license "BSD-2-Clause"
  head "https://github.com/ptpd/ptpd.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_macos do
    on_intel do
      url "https://github.com/ptpd/ptpd.git", revision: "1ec9e650b03e6bd75dd3179fb5f09862ebdc54bf"
    end
    on_arm do
      url "https://github.com/ptpd/ptpd.git", revision: "1ec9e650b03e6bd75dd3179fb5f09862ebdc54bf"
    end
  end

  def install
    system "autoreconf", "-vi"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/ptpd2 -k #{share}/ptpd/ptpd2.conf.default-full", 1).strip
    assert_equal "Error: ptpd2 daemon can only be run as root", output
  end
end
