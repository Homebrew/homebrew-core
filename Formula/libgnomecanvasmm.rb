class Libgnomecanvasmm < Formula
  desc "C++ wrapper for libgnomecanvas"
  homepage "https://gitlab.gnome.org/Archive/libgnomecanvasmm"
  url "https://download.gnome.org/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2"
  sha256 "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918"
  license "LGPL-2.1-or-later"
  revision 12

  bottle do
    sha256 cellar: :any, arm64_ventura: "81a7ee7ee9fd49656bb3a25d583f625a6230647ffc33fc3bec56c8710efafec3"
    sha256 cellar: :any, arm64_big_sur: "fdb748c4593e0ed588493f471ce80d9ebea3d7026020ecfab5d98d8288fd32a4"
    sha256 cellar: :any, ventura:       "0f2b9a67b07edc4cce4179100848ca30b4a1e5b587cf0dbef27c757fbb55fcc9"
    sha256 cellar: :any, monterey:      "01f2b10ca95a77193ef1ee329b56948a196fbe1dd6610ba8988eb8c26424fed9"
    sha256 cellar: :any, big_sur:       "fbc2efc9e87a6f201ac94b37358d0464fbf2b2a277d1bfdbe2a626236cf41771"
    sha256 cellar: :any, catalina:      "e92ef2275ecd56b74a7a7f5a6e795c4f1d6a0deecd8f91647bdb62610397b058"
    sha256 cellar: :any, mojave:        "a0d170f35e076cde6587dc614dbb705d0ecf673a5426ee47a13fdf1ba8f6eae0"
  end

  deprecate! date: "2022-02-28", because: :repo_archived

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "libgnomecanvas"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libgnomecanvasmm.h>

      int main(int argc, char *argv[]) {
        Gnome::Canvas::init();
        return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libgnomecanvasmm-2.6"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
