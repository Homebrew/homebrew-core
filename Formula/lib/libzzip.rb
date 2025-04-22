class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/refs/tags/v0.13.79.tar.gz"
  sha256 "ed6f3017bb353b4a8f730c31a2fa065adb2d264c00d922aada48a5893eda26e4"
  license any_of: ["LGPL-2.0-or-later", "MPL-1.1"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eefa13cafc8183879063dbe16579e3343c76d27279553059dadc1b44d3933e5a"
    sha256 cellar: :any,                 arm64_sonoma:  "38d51c19c574872633dda1817897c67f3834fbf9a8bbae9ad3afeaebdeb0e171"
    sha256 cellar: :any,                 arm64_ventura: "8cf911ef7b6fede99b360a865120e38c98ef4765e6d4ae0a74fe4a6e5f5c85aa"
    sha256 cellar: :any,                 sonoma:        "13f3a193ebbacdc641b21d5d6b20bf58ba68aaf2f42317d88887c4d382fe401c"
    sha256 cellar: :any,                 ventura:       "e87accc479f28da3af284019fcda811b7da43364395bff087e6f25055e3b8b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b810551e086a12ee27c7e781bfe1e6f0cbff78e5052d48d278a228c4107697f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c15fecb424c383a12433edf9ac37aca7b6494ee33741aa55155acafdbf9cb6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build
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
