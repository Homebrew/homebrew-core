class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.13/kyua-0.13.tar.gz"
  sha256 "db6e5d341d5cf7e49e50aa361243e19087a00ba33742b0855d2685c0b8e721d6"
  revision 1

  bottle do
    sha256 "a210c64c138b1656093b103ae27d9354972d7c2ec1e7220b0d94a9bc6806522c" => :mojave
    sha256 "ecf3850322d6a575b63519a21f6bfe7eb652c67564f7292f017306d468cbf49d" => :high_sierra
    sha256 "b533f71a13a6b8bdbbc4778515f5701774175879d6171804f43c1da8e12b4217" => :sierra
    sha256 "e2449019eb1bd161b222fc73136990a4bed0ab4349b288ceff49add0b8958572" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "atf"
  depends_on "lua"
  depends_on "lutok"
  depends_on "sqlite"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
