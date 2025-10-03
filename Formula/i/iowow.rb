class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://iowow.softmotions.com"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.4.18.tar.gz"
  sha256 "ef4ee56dd77ce326fff25b6f41e7d78303322cca3f11cf5683ce9abfda34faf9"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b21a214c32770aca0640784c45fdf33489db118e3051c66d8bfa2c9958386a8e"
    sha256 cellar: :any,                 arm64_sequoia:  "037aeefb4df2c9cc2c239192b51713f918271e48455c48bdebbcf2d688bb212f"
    sha256 cellar: :any,                 arm64_sonoma:   "2fba078871f285e4275e5335150ef00f6615d5739d7a9280919edf787f9a0b5f"
    sha256 cellar: :any,                 arm64_ventura:  "653db3534479fa6987b0276850e13ae821507a3eb40131f9170e4ce1158bf56e"
    sha256 cellar: :any,                 arm64_monterey: "02ac4f8dc19959efbfd5bbac2685c2532e9de9488f3f51a218e15b2767727559"
    sha256 cellar: :any,                 sonoma:         "bfdd0df35ade257dfc24898f77d0134176f5d3c13a12338c4d0e705451bb269d"
    sha256 cellar: :any,                 ventura:        "e222abf0c1723ef6439607386f136582ef7384aa2c5df9e989386f3be4c5e5c1"
    sha256 cellar: :any,                 monterey:       "791aad132a5be42cbde1b97c8f38dc6c63f84f382aa94980b9fc5371778deb20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b3ddbc7bd008a380416bef79e794b4ab3e1085309c6b5f22b2fed244dceca09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c50abbc4cf8ac933da6dc4be5dab2ca27db4e653fa7eb7189f00378561c3d7e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "src/kv/examples/example1.c", "#include \"iwkv.h\"", "#include <iowow/iwkv.h>"
    (pkgshare/"examples").install "src/kv/examples/example1.c"
  end

  test do
    system ENV.cc, pkgshare/"examples/example1.c", "-I#{include}", "-L#{lib}", "-liowow", "-o", "example1"
    assert_match "put: foo => bar\nget: foo => bar\n", shell_output("./example1")
  end
end
