class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 1

  bottle do
    sha256 "889d0a069ddabc301f296cd70661d1d9a632e16c813bd0f520b04f03ae13394b" => :sierra
    sha256 "e20a113826505f2ad7fe738d8c12e5278e67fbc4d86d456b387d6b647c71b35f" => :el_capitan
    sha256 "5fbde423de599dac2f3b9af5f5e07bcc0015704f1beeb86847ebfacf9a84b7fc" => :yosemite
    sha256 "7e730887010cb06350e57693fb6d1bae74212a5820b055af3104d698d85d103a" => :mavericks
  end

  head do
    url "https://github.com/konoha-project/konoha3.git"

    depends_on "openssl"
  end

  option "with-test", "Verify the build with make test (May currently fail)"

  deprecated_option "tests" => "with-test"

  depends_on "cmake" => :build
  depends_on :mpi => [:cc, :cxx]
  depends_on "pcre"
  depends_on "json-c"
  depends_on "sqlite"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on :python if MacOS.version <= :snow_leopard # for python glue code

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      # `make test` currently fails. Reported upstream:
      # https://github.com/konoha-project/konoha3/issues/438
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write "System.p(\"Hello World!\");"
    output = shell_output("#{bin}/konoha #{testpath}/test")
    assert_match "(test:1) Hello World!", output
  end
end
