class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "3ddf869bc6db6874837b82b32f1fddc9bf7ff34fc1315eb967610aee294822eb"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b812fd1c1de4081bb9e3bc630727f251563f0e4186da7c765da8404ee7e70c63"
    sha256 cellar: :any,                 arm64_ventura:  "49d2e9cc5a880d52e2210d19e2bdf57b3567593b4eafbb2a84e03932d9184c53"
    sha256 cellar: :any,                 arm64_monterey: "a46715c797da31aae979be10f4703f910a4de2552c033b309ae3a680be0ff64b"
    sha256 cellar: :any,                 sonoma:         "3539d0b628b2de24d2c2893104b7eb15614597e332891fc9caf56e6a2bc3be42"
    sha256 cellar: :any,                 ventura:        "841432860c3a37b9bbe61316cc4d4daab84b10bd866e2a5860b99d0c5cfbad82"
    sha256 cellar: :any,                 monterey:       "21ec12a5f10ed949cb785c8eaee3117d7c28212e4596343f19bfd0de1c8748c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b880564f4678a439821e726f7ee6ae0ef726e30df2627cf05baa775fe9fb9c"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
