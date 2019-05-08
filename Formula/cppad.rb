class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20190200.2.tar.gz"
  sha256 "a745f6f6a3e5dd78e97a20c5396fd9217242b79cdbaf6768fe6feb19a6fad524"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00b5cd1f773116274669f36eaf037816aa016a2acc00256076e24f63e429d91b" => :mojave
    sha256 "00b5cd1f773116274669f36eaf037816aa016a2acc00256076e24f63e429d91b" => :high_sierra
    sha256 "53c33dcd82bcd8b89d6738d6a9487e63dd0f014bc8534c20600796179df45618" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
