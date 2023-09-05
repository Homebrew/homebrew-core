class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-1.0.1.tar.gz"
  sha256 "0f7f4b8a76a2cdb284fddef20de8306450df6dd031a47a15ac95bc43c3358e09"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "85b7fa56075fd5cfc7ac2826db04393bcedc532d6c1b7e77a0fb9640b73dae23"
    sha256 arm64_monterey: "705425ac57b11d428626f70ef1fc7b3a9bb137b11797445f6e6121cd5c677222"
    sha256 arm64_big_sur:  "646fda7aeff0ecf305688e1f1752bd78e0d9477508d9c4e71b96c2ee2ce31259"
    sha256 ventura:        "a3979d91880e97d250a9f2decb2655c8d5bbccb7be0f48468fd65826ce40a4b5"
    sha256 monterey:       "96e2da3790877a51e93bb65e67781e203fc7c73387ac5aaa14f578627bd60fa2"
    sha256 big_sur:        "6160d5afc05b64c8cdfb836b0d35972bf573de4136068e4f4f1ddec32a9674c7"
    sha256 x86_64_linux:   "6a64eeff8dc7fba4f39ed8a4d25908f7757c175f21de3ff72ed62852d8275304"
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
    system "#{bin}/capnp", "compile", "-oc++", testpath/"person.capnp"

    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-c", testpath/"test.cpp", "-I#{include}", "-o", "test.o", "-fPIC", "-std=c++1y"
    system ENV.cxx, "-shared", testpath/"test.o", "-L#{lib}", "-fPIC", "-lcapnp", "-lkj"
  end
end
