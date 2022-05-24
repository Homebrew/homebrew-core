class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.10.tar.gz"
  sha256 "cf60b2a80f6bfc9a6b110e18f08309040ceaa755210bf94c465a969da7524d07"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "de303c8dc164622e39d9091dbe666b508616d85701a1f41382e80cb0f7ee3092"
    sha256 cellar: :any,                 arm64_big_sur:  "e94302c8cda17fbcdc68e912d5ed673572f6c08812b582db9bebdbc3fc837945"
    sha256 cellar: :any,                 monterey:       "cc40497e1a32f03ef88145402e4b1c8c4ffb0c6686ca1c6777819be09e4065e8"
    sha256 cellar: :any,                 big_sur:        "27e180a019179942a0131eac3f8a52422194af080313ea730390624a8ab83e28"
    sha256 cellar: :any,                 catalina:       "125aaff11e8e92efdd6159d21133689ba8af9d3f13208994850ce4f8a7e7a9dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec70453fc82893b76d4e4c57585d582b99fde8b8f3340df02c580a04f494192"
  end

  depends_on "ghostscript"

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
