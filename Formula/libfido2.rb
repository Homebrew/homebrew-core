class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.11.0.tar.gz"
  sha256 "0830c5853e3b44099a97166e0cec54a65b54b7faaac07071872f77b8e4d7b302"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e78d1d760c1c61c74ea753e38f1803aafdc516b83f446dddb43edc5245475ed3"
    sha256 cellar: :any,                 arm64_big_sur:  "fae3b6cb7a4b24319560f28fb5610fb4fb6d2ae8e46cd346c0416ecdd16eb9bd"
    sha256 cellar: :any,                 monterey:       "61720be49bd0fdb87b7900122e22511514f87e0d5c73eb186664bfeee274f451"
    sha256 cellar: :any,                 big_sur:        "be93faeb2280ef841a93421db701352db1e6793840d80de120dbf9483b121325"
    sha256 cellar: :any,                 catalina:       "d01757fc3134f2dc4ba3e0c2ea8356915a2301eaab361bc3ed6d5f4d2977cd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc8bb06403f1c6d9402bb9f939e567da061e0e1fe351677a79624800a91ae6f"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    args = std_cmake_args

    args << "-DUDEV_RULES_DIR=#{lib}/udev/rules.d" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["openssl@1.1"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
