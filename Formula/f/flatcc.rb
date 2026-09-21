class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "463c1cbc95777a01e103a6c961325f28e8876cb44a195b5c0f8d1117ae019580"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b390488a0565e30084d6d5e1e69e975de78ee116e1ccb4eea8a7478865c3af09"
    sha256 cellar: :any, arm64_tahoe:       "a66439c7140f8c2b781fd4bdcb1b00987b56b851c012f04779da95372aad8483"
    sha256 cellar: :any, arm64_sequoia:     "9fb98c5faffdde130da5702211e6f6db22e8a68259875acedde5ac573c0c0e8e"
    sha256 cellar: :any, arm64_linux:       "64a9b89080a483267b415722dd07ecc104a5e98550f02cd2a0e7957bfdfef717"
    sha256 cellar: :any, x86_64_linux:      "3e06eef49163cc53d7d069671cece04dcca4a4b214a5110b421153e472f2ac3a"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DFLATCC_INSTALL=ON
      -DFLATCC_INSTALL_LIB=#{lib}
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fbs").write <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

    EOS

    system bin/"flatcc", "-av", "--json", "test.fbs"
  end
end
