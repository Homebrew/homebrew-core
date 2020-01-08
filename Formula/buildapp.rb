class Buildapp < Formula
  desc "Creates executables with SBCL"
  homepage "https://www.xach.com/lisp/buildapp/"
  url "https://github.com/xach/buildapp/archive/release-1.5.6.tar.gz"
  sha256 "d77fb6c151605da660b909af058206f7fe7d9faf972e2c30876d42cb03d6a3ed"
  revision 1
  head "https://github.com/xach/buildapp.git"

  bottle do
    sha256 "7954a9008618ee64fbf2b93b1b2f503e25e979efaf5f10afee916d455ac3e231" => :catalina
    sha256 "86fa0142bbde84222c65edec4f082b99d7fbd67c4767723025fd12c9f60b2db4" => :mojave
    sha256 "aa14506cc1ab8eb712c9b1fdb71af45c9041b327c9ecdf9d48541b652e3da3be" => :high_sierra
    sha256 "15e1be1e7928770abfdb801e67435b9d7c1bc36923bc6d9d5281d9ceab0d9abd" => :sierra
    sha256 "49d62ce2b8564d5456725d1a7cedafb38690d9bcdf5e7b6f279805665ed65833" => :el_capitan
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
