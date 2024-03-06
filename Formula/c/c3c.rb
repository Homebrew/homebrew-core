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
    sha256 cellar: :any,                 arm64_sonoma:   "59da593b5fed0a0acdc531ed9ea9102332de427be712cd44adf423f05fe63b29"
    sha256 cellar: :any,                 arm64_ventura:  "604d8aa7d7361540002269c5bb6701af984d67fde0bb9547367a8a3ded53d69c"
    sha256 cellar: :any,                 arm64_monterey: "3d34e5d9030c63d881c6b01f63d0723823b9ea8eb3a2ee16c4870226070add36"
    sha256 cellar: :any,                 sonoma:         "db80f839f124bb1b8a5c526878887ae477c6e5ea2e7b3b6c1b76e80a936b507f"
    sha256 cellar: :any,                 ventura:        "d83d6b6ae747f56ddfe092d7537fcd1d2461fa88eef8116dde1b57f43c38b116"
    sha256 cellar: :any,                 monterey:       "8ca5d00c2e6f43ff82bcfe323908846235f3e344b0864a38f782a84442eda02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3789ee2fe5656d38515b174bff1dd81efde2eef3b98af72f65c32b3d08899f"
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
