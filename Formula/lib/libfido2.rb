class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.14.0.tar.gz"
  sha256 "3601792e320032d428002c4cce8499a4c7b803319051a25a0c9f1f138ffee45a"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "124c6acd3f42b69035cdf61dc1a03b3fdf86c1290a3c9ad3144c4732d25b798c"
    sha256 cellar: :any,                 arm64_ventura:  "42504c5bc3a7895b31365222687510f4ff386f129072b2e73b365e1e1d69f2f8"
    sha256 cellar: :any,                 arm64_monterey: "c9f675b9b835f8b391bda4c63c20d24fda863649b5154537da2373b6835ca9ea"
    sha256 cellar: :any,                 sonoma:         "3dee804ca54bc15d99e4a47cbecec62e7ffe64323afa476811bf1b2c7f8326bd"
    sha256 cellar: :any,                 ventura:        "6e06c97e6d5231ac270ea458d2d528826fbef7438cc3973ce2a10ed09a9896d9"
    sha256 cellar: :any,                 monterey:       "0fcdef5244969f2f450415daa7a51aafac325f0ed0cf63215306ca6017c17094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a9fe328eb53484cda674637c633c9cd0030593f2efc6bcb249ee7cb19c6bd6"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@3"

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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["openssl@3"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system "./test"
  end
end
