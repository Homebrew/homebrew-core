class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.7.0.tar.gz"
  sha256 "da462387a467661cb9d0ec9b667aecd7be3f54ce662cfbb2292f4795fd3f7f20"
  head "https://github.com/oilshell/oil.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
