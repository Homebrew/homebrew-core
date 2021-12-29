class Libiberty < Formula
  desc "Collection of subroutines used by various GNU programs"
  homepage "https://gcc.gnu.org/onlinedocs/libiberty"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  depends_on "gcc" => :build

  def install
    ENV.append_to_cflags "-fPIC"

    args = %W[
      --prefix=#{prefix}
      --enable-install-libiberty
    ]

    mkdir "build" do
      system "../libiberty/configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <string.h>
      #include <iostream>
      #include <typeinfo>
      # define HAVE_DECL_BASENAME 1
      #include <libiberty/demangle.h>
      int main() {
        std::string str(
            cplus_demangle_v3(typeid(int64_t).name(), DMGL_PARAMS | DMGL_ANSI | DMGL_TYPES));
        std::cout << str << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{opt_include}", "#{opt_lib}/libiberty.a"

    assert_match "long", shell_output("./a.out")
  end
end
