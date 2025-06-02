class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-1.1.0.tar.gz"
  sha256 "07167580e563f5e821e3b2af1c238c16ec7181612650c5901330fa9a0da50939"
  license "MIT"
  revision 1
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "da943b772529cbb7c2440eb94cd2f10f46c6c8581ff71955c91eb525f02ef77c"
    sha256 arm64_sonoma:  "65f9b719ce1f34ad4ecf701c4746a8171373f6823cb49092240a72873a236e26"
    sha256 arm64_ventura: "a189e48e415f6c948dc65316273d4e3ef61c382afc8e87b3e0f9ff39de1a756b"
    sha256 sonoma:        "b10e583f8c1e19e55799c99976bdcf1a72525159d1dafbbf34ce81e0e23e27f6"
    sha256 ventura:       "5b7db9d3f90102f106d9fb4c4f9a940d6c3f41ec88d37b43448935e98cd0d8c8"
    sha256 arm64_linux:   "c1e25a52e5c2c575e99556aaf4f201e62ee6bda6f9c4ad126e6f92a1a4949a0d"
    sha256 x86_64_linux:  "565ef7ec4280086a04817c3b66eacff9fb21bb572e83a29a9aba77535bce0d8b"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DCMAKE_CXX_STANDARD=20", # compile coroutine support, remove with 2.0 update
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static",
                    "-DCMAKE_CXX_STANDARD=20", # compile coroutine support, remove with 2.0 update
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install buildpath.glob("build_static/src/capnp/*.a")
    lib.install buildpath.glob("build_static/src/kj/*.a")
  end

  test do
    ENV["PWD"] = testpath.to_s

    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")

    (testpath/"person.capnp").write <<~EOS
      @0x8e0594c8abeb307c;
      struct Person {
        id @0 :UInt32;
        name @1 :Text;
        email @2 :Text;
      }
    EOS
    system bin/"capnp", "compile", "-oc++", testpath/"person.capnp"

    (testpath/"test.cpp").write <<~CPP
      #include "person.capnp.h"
      #include <capnp/message.h>
      #include <capnp/serialize-packed.h>
      #include <iostream>
      void printPerson(int fd) {
        ::capnp::PackedFdMessageReader message(fd);
        Person::Reader person = message.getRoot<Person>();

        std::cout << person.getName().cStr() << ": "
                  << person.getEmail().cStr() << std::endl;
      }
    CPP
    system ENV.cxx, "-c", testpath/"test.cpp", "-I#{include}", "-o", "test.o", "-fPIC", "-std=c++1y"
    system ENV.cxx, "-shared", testpath/"test.o", "-L#{lib}", "-fPIC", "-lcapnp", "-lkj"
  end
end
