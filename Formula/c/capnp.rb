class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://github.com/capnproto/capnproto/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d5ebdf858e9885c33d4b3f765006d68bd66e9b002bf4d607ff4317ef9c1aac6a"
  license "MIT"
  compatibility_version 3
  head "https://github.com/capnproto/capnproto.git", branch: "v2"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5665a71fb8c0b1fcb4a093a9184af9f7e0c272a50dfa1034c720f9aefbfa5853"
    sha256 arm64_sequoia: "631e9a4c90da11c4c4530ffab27ab993c309af1ab40f5db0ea4303210e01dab8"
    sha256 arm64_sonoma:  "6528998926fad4016e93d0ba899fed20e460b410562bce475542ace24f25303e"
    sha256 sonoma:        "5f137b8eabb0147b51e77bfc9ec99855ae0231a1aa54a2f9df3fcc97beaff527"
    sha256 arm64_linux:   "40568ae1e83cafce1333b0880b29e841fefb81e886201046edffe5dca9eed83f"
    sha256 x86_64_linux:  "53597d8b7773ca1762768b64538c5c5ecd85fe01b6b0fc9537f568c64a6de8ad"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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
    lib.install buildpath.glob("build_static/c++/src/capnp/*.a")
    lib.install buildpath.glob("build_static/c++/src/kj/*.a")
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
