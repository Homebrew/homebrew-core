class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-1.1.0.tar.gz"
  sha256 "07167580e563f5e821e3b2af1c238c16ec7181612650c5901330fa9a0da50939"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "86158801e5d5a2131d80c2526855da900d3f333080b19f8ed77ec4489b258721"
    sha256 arm64_sonoma:   "19bd2ac85d9b982d0f5bb2cbf728823aeb1ceed838096c55459f1b973f6d9733"
    sha256 arm64_ventura:  "f9f10d39ccda6aac9d9e4dee159dd2e882ba5cd027a8b19216f498fd1c39ae72"
    sha256 arm64_monterey: "d4db0fb57022ca7980f402cdde520987d37ee66caaaa61b78037136b4476225f"
    sha256 sonoma:         "5b90bfe71f8f407f71c0d0f3404a02607eb3d1fcc903067cce628653dd5c00ed"
    sha256 ventura:        "37ba767871207bc87d5869e343738a4db44e8357366d7f6165618ddf211bd968"
    sha256 monterey:       "ddd4e35539498174d233ed6fec3fce40c3ee7b2d61b93f5114e6b6eba5784e83"
    sha256 x86_64_linux:   "28f2ac2e3b0ab17b31bcf092c2e3e6d810d5601e0a17e09c2a12872a4ec57348"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static",
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
