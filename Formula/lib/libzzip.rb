class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.80.tar.gz"
  sha256 "21f40d111c0f7a398cfee3b0a30b20c5d92124b08ea4290055fbfe7bdd53a22c"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "69735dbc14d4c13a8f0c66f8dd6012e2f9618a79033d87a899cac0c84e31cf22"
    sha256 cellar: :any,                 arm64_sequoia: "41c0248393555b1c550213bb84e033a57182585de9f305a2834b371911842261"
    sha256 cellar: :any,                 arm64_sonoma:  "284eb1a2fba26c513f28eb79f8a2126f4ef419393d0f6a5ad7acbe791502277c"
    sha256 cellar: :any,                 sonoma:        "ea36297cb31148dec501489f673b73bd6975582c6ceab0cef2c1958c02a0bfad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e9eb837697a4f0bbaf369811bf8a58f0598c333886438a3ed5934b163f0cb99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893de6dc5addc31b890f9815d24a1f4f1fa4dfc4a497132ecc12f224c205e4de"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zip" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
