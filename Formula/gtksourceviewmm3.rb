class Gtksourceviewmm3 < Formula
  desc "C++ bindings for gtksourceview3"
  homepage "https://gitlab.gnome.org/GNOME/gtksourceviewmm"
  url "https://download.gnome.org/sources/gtksourceviewmm/3.18/gtksourceviewmm-3.18.0.tar.xz"
  sha256 "51081ae3d37975dae33d3f6a40621d85cb68f4b36ae3835eec1513482aacfb39"
  license "LGPL-2.1-or-later"
  revision 10

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35d19a368cbe09ef00c30b816e506665229bd2fcaa683594007ac3883433ae9f"
    sha256 cellar: :any,                 arm64_monterey: "0f6143ae59613281896b8e61962728fa445e0f01238be952dfeb8402e8de6796"
    sha256 cellar: :any,                 arm64_big_sur:  "787713d0f6802ea858aa728be88507a6d1b3adc6e3e648c34af059651393e83a"
    sha256 cellar: :any,                 ventura:        "08044847e23c51115e5a4b8030d511857a9452addd35fd8bf7a0ce5b98095ae2"
    sha256 cellar: :any,                 monterey:       "e3f82bddf2add81a84854eac842b29528e19175bcf473a5c29fdecb21702b49b"
    sha256 cellar: :any,                 big_sur:        "e1cc731cb3f1d99a040da7719e8d91f325d7c00a46e19a10ffca8d1ec87991e8"
    sha256 cellar: :any,                 catalina:       "2909f29ff9dce4266ba101d992bb8831487cd2084f467faad39198ce6923b729"
    sha256 cellar: :any,                 mojave:         "548c9dfe0eb1fbbe8bf9234a3d631bc232514855457372633f37bf240e427a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6de37b2284288c47e137939d4ff2eea5e235cc8967fddf00e227ed87b28855d"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm3"
  depends_on "gtksourceview3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        Gsv::init();
        return 0;
      }
    EOS
    ENV.libxml2
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceviewmm-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
