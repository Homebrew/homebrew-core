class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/xach/buildapp.git"

  bottle do
    sha256 "55bb441ef8f0eed0e698f246541dcf874bbe652de2897d9deb89a2999c2c239b" => :big_sur
    sha256 "631fa946cd687d3cc593fa43e489c96814de75fc6b98adebf11258d1f2043bd5" => :catalina
    sha256 "607c7238095cd1da76f2439679ed77ec4467649febfbbf99a24aefe0f23616b9" => :mojave
  end

  depends_on "sbcl"

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    code = "(defun f (a) (declare (ignore a)) (write-line \"Hello, homebrew\"))"
    system "#{bin}/buildapp", "--eval", code,
                              "--entry", "f",
                              "--output", "t"
    assert_equal `./t`, "Hello, homebrew\n"
  end
end
