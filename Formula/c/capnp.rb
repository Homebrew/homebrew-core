class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-1.0.0.tar.gz"
  sha256 "4829b3b5f5d03ea83cf6eabd18ceac04ab393398322427eda4411d9f1d017ea9"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6c2d8a399f6b2b7eeb3b4bc5eb3520f170e2d83666d6b4e2ef922b75054b5c9a"
    sha256 arm64_monterey: "3ab20257244e6efc9b47cfd12f68fcb1bab866c141a5a3600e1f9ba573e8876e"
    sha256 arm64_big_sur:  "5e03fd4d01b8951fade183b73994a4b8f00415177c08133ff94f0d415cbfa162"
    sha256 ventura:        "a57c156bf9c34baf6a510f0cea2bd15716e274468255981f5583de3f4ca7aa3e"
    sha256 monterey:       "a45dbdecc39c35b5889d62f1768729e4e6e1a2f108837097b86c3abb7abf0fe1"
    sha256 big_sur:        "8502c3d2ac9725545bae86497ea82707ad755ca895f1f37811a322289553e675"
    sha256 x86_64_linux:   "5b2f7489c8f7532b5f0f0e3a08760944f47bcad6f1232c79a7291928faeda445"
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
