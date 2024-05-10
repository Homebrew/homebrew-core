class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.74.tar.gz"
  sha256 "319093aa98d39453f3ea2486a86d8a2fab2d5632f6633a2665318723a908eecf"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aca4eab72c715ab7d983c686a1a97da2f304fbf839320bd9633387a08c4181af"
    sha256 cellar: :any,                 arm64_ventura:  "06c305eb6482de3e0230a402daaefdf05bc226648542657023ac67e5aad32fc2"
    sha256 cellar: :any,                 arm64_monterey: "787bceef891ae29d120d2ea694a74e651fce950efd4d57c69e50aee04973e1fb"
    sha256 cellar: :any,                 sonoma:         "b330e7536ae28e15f91b3555d7f8cbbcebe844fed4626c8681b65759778a28fc"
    sha256 cellar: :any,                 ventura:        "51afecd606b2e052e77959fff735027a9287c9c1a507a8b45fb5cae8e1e4d892"
    sha256 cellar: :any,                 monterey:       "defa6e5009fc00307cbcfc3e08b200aed53075267d871947873e8dbfb4d1b369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e99b10c38cc9dde767e9340519cf325a810254591b36541496a645a0e7968a7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    args = %W[
      -DZZIPTEST=OFF
      -DZZIPSDL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
