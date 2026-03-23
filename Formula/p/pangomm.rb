class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.gtk.org/docs/architecture/pango"
  url "https://download.gnome.org/sources/pangomm/2.56/pangomm-2.56.1.tar.xz"
  sha256 "539f5aa60e9bdc6b955bb448e2a62cc14562744df690258040fbb74bf885755d"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47f6a5d2a8b3d0ba246aae39234a138ce18d1004ec35607b18f22f203b250171"
    sha256 cellar: :any, arm64_sequoia: "fc97b28b6c7113305951d34c674a9f7a3eb480fe22e934258e1224da19ac8863"
    sha256 cellar: :any, arm64_sonoma:  "110fdbe5d554355086809c40170027d39daaf2adde15e25dd43001ea968c1303"
    sha256 cellar: :any, arm64_ventura: "51147a02ebc43f6a0123d07c680512e7135750f0bfe1175217556f578f17ad3b"
    sha256 cellar: :any, sonoma:        "1bc3b3ef3f4502d595eec7787bc1464723abfdae305ed2b4118c5d1bce59a61d"
    sha256 cellar: :any, ventura:       "c57567987e6f32bbf3a1cd9860c52df97753f34eaab7dcb5b72539f0a57c0fdc"
    sha256               arm64_linux:   "2ba333c4cb46d9e32440117b87ca21123dda59066c5edf1120ab77e98c9e1289"
    sha256               x86_64_linux:  "4defbd47ef262aaf9aa021ab3da046d717848c61679f0f412278d74c1877d6f7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairomm"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libsigc++"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    CPP

    pkgconf_flags = shell_output("pkgconf --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkgconf_flags, "-o", "test"
    system "./test"
  end
end
