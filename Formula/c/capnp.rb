class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://github.com/capnproto/capnproto/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "d14a9149b79c055fee9d5aa778defe8e8cee0d2a11f0729865cd30dcc345eef2"
  license "MIT"
  compatibility_version 2
  head "https://github.com/capnproto/capnproto.git", branch: "v2"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e999051c6f5a36c7b626b9f97768554550058d87a8fbd9d57cdd4ba3b1e95a5a"
    sha256 arm64_sequoia: "838748596b9229739ca78e07515ee3b0dd6e06a92d5952a3a6343c3672b33e94"
    sha256 arm64_sonoma:  "9706e2380a2f38cfa7793c23a39368ceada6435eab01c19faad152253536c54a"
    sha256 sonoma:        "77e1fd35cebbacde953d7efe689ea99a815d5a896ed262431c7a3310326e7083"
    sha256 arm64_linux:   "dbbacfe6f0d69f2daf5af810f78c7e50029bb6f2c93ab48256345df311b9423c"
    sha256 x86_64_linux:  "28db17788d75c20523d3da4796cc1bd20ba1e2fc5bfe0de09a6cc5fe0ae106b9"
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
