class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.4.1.tar.gz"
  sha256 "4104905394f1313c47e22d4c81e9df538b90cec9004b3230d68cd055b84f5715"
  head "https://github.com/pixel/hexedit.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a876b73ca63a0da195ddee709716ca973d579b85062a93f85261500f8ffeb612" => :sierra
    sha256 "078d2bd1b7fd56db28b0b4d972826aedd117e810d9a885b5b2545cd8e5e5ccd5" => :el_capitan
    sha256 "4f06836e7a2f4a280084fe8f9f5ff3903272a6e9995f24bf93156afc56d7b996" => :yosemite
    sha256 "1931661462fffa57fb8b0b6b7cb3c4439ed72b93f5a0a6db94e9bb2f5fa1cd4d" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
