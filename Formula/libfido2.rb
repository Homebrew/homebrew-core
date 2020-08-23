class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.4.0.tar.gz"
  sha256 "ad921fbe7d4bb70e4a971e564cd01f341daf9b5ed5d69b3cbab94a8a811d2a6c"
  license "BSD-2-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "aa56164db657cfbef40a03155bedfbecdd4aca07fc240503346b73ba850d26d9" => :catalina
    sha256 "8621d7376e70e75db430698b392aaa0c230bff55ebbc34218b9c9acfbae17960" => :mojave
    sha256 "13df15672e11395e0d056d3e82f533bbe208b57f8adb7f3f116955d31527e1b2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@1.1"

  # Apply fix for https://github.com/Yubico/libfido2/issues/166 (also https://github.com/Yubico/libfido2/issues/179)
  patch do
    url "https://github.com/Yubico/libfido2/commit/39544a2c342b0438a8f341b4a4ff20f650f701a3.diff?full_index=1"
    sha256 "664a95d68502a266835839002d32149ae391aef5b902d33a990c00539a68fe32"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "man_symlink_html"
      system "make", "man_symlink"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOF
    #include <stddef.h>
    #include <stdio.h>
    #include <fido.h>
    int main(void) {
      fido_init(FIDO_DEBUG);
      // Attempt to enumerate up to five FIDO/U2F devices. Five is an arbitrary number.
      size_t max_devices = 5;
      fido_dev_info_t *devlist;
      if ((devlist = fido_dev_info_new(max_devices)) == NULL)
        return 1;
      size_t found_devices = 0;
      int error;
      if ((error = fido_dev_info_manifest(devlist, max_devices, &found_devices)) == FIDO_OK)
        printf("FIDO/U2F devices found: %s\\n", found_devices ? "Some" : "None");
      fido_dev_info_free(&devlist, max_devices);
    }
    EOF
    system ENV.cc, "-std=c99", "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
