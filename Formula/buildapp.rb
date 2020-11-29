class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/xach/buildapp.git"

  bottle do
    sha256 "afe8b36fb0028cc1ed5d8ff32d9d54496bd8ab52c196794155489160335452a4" => :big_sur
    sha256 "a0177161f65808315986f1eaab3305ffcf9ca03fff434687f6354d0711e7c9ef" => :catalina
    sha256 "d4721d62fb334d49ac7730a4110826efeac3b0b8db25671a20ce20258ff303a3" => :mojave
    sha256 "87758d9045461b6b9cf23dd9b75e328a8b817a0e12703a696b93dd574396cd72" => :high_sierra
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
