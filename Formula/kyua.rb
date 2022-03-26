class Kyua < Formula
  desc "Testing framework for infrastructure software"
  homepage "https://github.com/jmmv/kyua"
  url "https://github.com/jmmv/kyua/releases/download/kyua-0.13/kyua-0.13.tar.gz"
  sha256 "db6e5d341d5cf7e49e50aa361243e19087a00ba33742b0855d2685c0b8e721d6"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 arm64_monterey: "8e53cdb607af1f2aded06f7c2348f976f02cc413167bf7d9c84ed8df28022764"
    sha256 arm64_big_sur:  "0de5560c3fe849a4d1739c041b4b70a235929ac1323a9e7f1a1769c69ae6b363"
    sha256 monterey:       "333cca57c2a7eab8dfc5f42e026a1c646a50a33e4722553cfa9772311c32b89d"
    sha256 big_sur:        "33c93cc065968275bdee21b772ada29ebe3776f7c1dacb297e6c3cb2804fcb20"
    sha256 catalina:       "5fba6da95b5e79c1fda0d118b0d67a4c74629a28e348ae4fab0dee1b770dccd4"
    sha256 mojave:         "b0d437da5f3f873795d6157dcc545a3ca72fef19d5288369a95b58ba5c8f4cc5"
    sha256 x86_64_linux:   "056d090e0c1c5175016cb64ac1d8cebdf86e052895afd90d663e7ee8d65757e4"
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
