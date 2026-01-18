class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://github.com/capnproto/capnproto/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "01ab2ba7f52fcc3c51a10e22935aae56f3bc5e99b726b7e507fe6700cb12147d"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "v2"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "830c585121ebefe42e7fd8687dc6c4a16791709ddc82400531e426decbbaf579"
    sha256 arm64_sequoia: "0b22246ef1430b58434c29e1060ebee51bfbc29d388ab0e97b3a7b6ea347aa93"
    sha256 arm64_sonoma:  "933447a496eb80984f2fede5b6483a77b9146e146473cdc4d18b24b90ccd0ca1"
    sha256 sonoma:        "020c95a5ec0a2aec01133ae4bd2571c6bd196ef705a4fbca5f27f365ed1b9580"
    sha256 arm64_linux:   "17188a4772e30b20fb5563630136e090ade04e78d2494598b2099431e714152f"
    sha256 x86_64_linux:  "1516426871f805f99d241f9a5b0d4d73c6c76ca698d232d85339fd9bbf2d4a14"
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
