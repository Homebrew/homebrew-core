class Libiberty < Formula
  desc "Collection of subroutines used by various GNU programs"
  homepage "https://gcc.gnu.org/onlinedocs/libiberty"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  sha256 "4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf"
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
      # define HAVE_DECL_BASENAME 1
      #include <libiberty/demangle.h>
      int main() {
        std::string str(
            cplus_demangle_v3(typeid(std::string).name(), DMGL_PARAMS | DMGL_ANSI | DMGL_TYPES));
        std::cout << str << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{opt_include}", "#{opt_lib}/libiberty.a"

    assert_match "std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >",
      shell_output("./a.out")
  end
end
