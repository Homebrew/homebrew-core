class Multitime < Formula
  desc "Time command execution over multiple executions"
  homepage "https://tratt.net/laurie/src/multitime/"
  url "https://github.com/ltratt/multitime/archive/multitime-1.4.tar.gz"
  sha256 "31597066239896ee74a3aaaea3b22931a50a1ec1470090c5457ef35500c44249"
  license "MIT"

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "autoheader"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/multitime -n 2 sleep 1 2>&1")
    assert_match(/((real|user|sys)\s+([01].\d{3}\s*){5}){3}/m, output)
  end
end
