class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.78/glibmm-2.78.0.tar.xz"
  sha256 "5d2e872564996f02a06d8bbac3677e7c394af8b00dd1526aebd47af842a3ef50"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "37305820c51b2adfc5bff7d0b2ce7998ca8909f4094a0a3b95a9ddbf97af4488"
    sha256 cellar: :any, arm64_ventura:  "37e656b380ad64863d0218db0780388f0e1fceb1ffb674b95a5cfa69789c85a8"
    sha256 cellar: :any, arm64_monterey: "1fa5ab892743a2b213acd2a735eff796f7e7d3f50cc45a560f4c9c46d6d14de2"
    sha256 cellar: :any, arm64_big_sur:  "eff4f6f6c591c54315c75624973cd470d832d1caa49e8d2ba97a7b24ef0e5a93"
    sha256 cellar: :any, sonoma:         "ad406c170ae3653b97d1b7fbc82838449b7040e130b7b2c16ab041f70f21dd81"
    sha256 cellar: :any, ventura:        "3c83fd75b8c6963ae7de271fd6c6ed20fe7995f0291fda24da5a049dd72bb975"
    sha256 cellar: :any, monterey:       "70867161b405e9b5b747f9cfbbbae4031003a746eb90d1608df005887f14d6e4"
    sha256 cellar: :any, big_sur:        "5548ca1f7902a3a9601103a74c4622205d9c843cce6ef05ba0c5c0899dd37b06"
    sha256               x86_64_linux:   "9f0f6ba6fc0c72876632b36ccb6563bad78840e9467e78e1f5020dc6a4edf32b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs glibmm-2.68").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
