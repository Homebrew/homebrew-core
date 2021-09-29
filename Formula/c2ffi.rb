class C2ffi < Formula
  desc "Clang-based FFI wrapper generator"
  homepage "https://github.com/rpav/c2ffi"
  url "https://github.com/rpav/c2ffi/archive/llvm-11.0.0.tar.gz"
  version "llvm-11.0.0"
  sha256 "7bc32f294c4d9e7e6ee3e04d45b1b8c04ae51872dbd90e8458c82c4cb98208e5"
  license "LGPL-2.1-only"
  head "https://github.com/rpav/c2ffi.git", branch: "llvm-11.0.0"

  depends_on "cmake" => :build
  depends_on "llvm@11"
  depends_on "qt@5"

  def install
    ENV["LDFLAGS"] = "-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
    system(
      "cmake", "-S", ".", "-B", "build",
      *std_cmake_args,
      "-DBUILD_CONFIG=Release",
      "-DCMAKE_C_COMPILER=#{Formula["llvm@11"].opt_bin/"clang"}",
      "-DCMAKE_CXX_COMPILER=#{Formula["llvm@11"].opt_bin/"clang++"}"
    )
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testfile1 = testpath/"demo1.h"
    testsource1 = <<~EOF
      #define MAGIC_NUMBER 543
      #define MIN_CARELESS(X, Y) (((X) < (Y)) ? (X) : (Y))
      float foo(float a, float b);
      void bar(int argv, char *args[]);
    EOF
    testfile1.write(testsource1)

    testfile2 = testpath/"demo2.h"
    testsource2 = <<~EOF
      #include "demo1.h"
      struct thing {
        char first_initial;
        char last_initial;
        void *spooky_stuff;
      };
      typedef struct thing thing_t;
      void *quux();
    EOF
    testfile2.write(testsource2)

    expected_stdout = <<~EOF
      [
        {
          "tag": "function",
          "name": "foo",
          "ns": 0,
          "location": "./demo1.h:3:7",
          "variadic": false,
          "inline": false,
          "storage-class": "none",
          "parameters": [
            {
              "tag": "parameter",
              "name": "a",
              "type": {
                "tag": ":float",
                "bit-size": 32,
                "bit-alignment": 32
              }
            },
            {
              "tag": "parameter",
              "name": "b",
              "type": {
                "tag": ":float",
                "bit-size": 32,
                "bit-alignment": 32
              }
            }
          ],
          "return-type": {
            "tag": ":float",
            "bit-size": 32,
            "bit-alignment": 32
          }
        },
        {
          "tag": "function",
          "name": "bar",
          "ns": 0,
          "location": "./demo1.h:4:6",
          "variadic": false,
          "inline": false,
          "storage-class": "none",
          "parameters": [
            {
              "tag": "parameter",
              "name": "argv",
              "type": {
                "tag": ":int",
                "bit-size": 32,
                "bit-alignment": 32
              }
            },
            {
              "tag": "parameter",
              "name": "args",
              "type": {
                "tag": ":pointer",
                "type": {
                  "tag": ":pointer",
                  "type": {
                    "tag": ":char",
                    "bit-size": 8,
                    "bit-alignment": 8
                  }
                }
              }
            }
          ],
          "return-type": {
            "tag": ":void"
          }
        },
        {
          "tag": "struct",
          "ns": 0,
          "name": "thing",
          "id": 0,
          "location": "./demo2.h:2:8",
          "bit-size": 128,
          "bit-alignment": 64,
          "fields": [
            {
              "tag": "field",
              "name": "first_initial",
              "bit-offset": 0,
              "bit-size": 8,
              "bit-alignment": 8,
              "type": {
                "tag": ":char",
                "bit-size": 8,
                "bit-alignment": 8
              }
            },
            {
              "tag": "field",
              "name": "last_initial",
              "bit-offset": 8,
              "bit-size": 8,
              "bit-alignment": 8,
              "type": {
                "tag": ":char",
                "bit-size": 8,
                "bit-alignment": 8
              }
            },
            {
              "tag": "field",
              "name": "spooky_stuff",
              "bit-offset": 64,
              "bit-size": 64,
              "bit-alignment": 64,
              "type": {
                "tag": ":pointer",
                "type": {
                  "tag": ":void"
                }
              }
            }
          ]
        },
        {
          "tag": "typedef",
          "ns": 0,
          "name": "thing_t",
          "location": "./demo2.h:7:22",
          "type": {
            "tag": ":struct",
            "name": "thing",
            "id": 1
          }
        },
        {
          "tag": "function",
          "name": "quux",
          "ns": 0,
          "location": "./demo2.h:8:7",
          "variadic": false,
          "inline": false,
          "storage-class": "none",
          "parameters": [],
          "return-type": {
            "tag": ":pointer",
            "type": {
              "tag": ":void"
            }
          }
        }
      ]
    EOF

    require "json"
    require "open3"

    test_stdout, _, test_process = Open3.capture3(
      "c2ffi", "--fail-on-error", "--std", "c99", "--lang", "c", "./demo2.h"
    )
    assert_equal test_process.exitstatus, 0
    assert_equal JSON.parse(test_stdout), JSON.parse(expected_stdout)
  end
end
