class Libgnomecanvasmm < Formula
  desc "C++ wrapper for libgnomecanvas"
  homepage "https://launchpad.net/libgnomecanvasmm"
  url "https://download.gnome.org/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2"
  sha256 "996577f97f459a574919e15ba7fee6af8cda38a87a98289e9a4f54752d83e918"
  license "LGPL-2.1-or-later"
  revision 11

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "109859d2925c79b17566e0aaef6ba7142b611a4b89c79d8568fe9de0cea113ba" => :big_sur
    sha256 "9c365e91a0c09cca8b2cde29b306f9f9b0ad4ac4f81ab09336150072530f0731" => :arm64_big_sur
    sha256 "11e5ae5c4a485d806232311f719cd7553cf88329c55efa0c4c01f60c4d77d9a3" => :catalina
    sha256 "92941b52627b1511007fc56a0f49ec3f19c13fd6c2e816e3649e50b5eb8b704e" => :mojave
  end

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
