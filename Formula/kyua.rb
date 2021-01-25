class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.13/kyua-0.13.tar.gz"
  sha256 "db6e5d341d5cf7e49e50aa361243e19087a00ba33742b0855d2685c0b8e721d6"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 "33c93cc065968275bdee21b772ada29ebe3776f7c1dacb297e6c3cb2804fcb20" => :big_sur
    sha256 "0de5560c3fe849a4d1739c041b4b70a235929ac1323a9e7f1a1769c69ae6b363" => :arm64_big_sur
    sha256 "5fba6da95b5e79c1fda0d118b0d67a4c74629a28e348ae4fab0dee1b770dccd4" => :catalina
    sha256 "b0d437da5f3f873795d6157dcc545a3ca72fef19d5288369a95b58ba5c8f4cc5" => :mojave
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
