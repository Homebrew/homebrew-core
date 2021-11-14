class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.9.0.tar.gz"
  sha256 "ba39e3af3736d2dfc8ad3d1cb6e3be7eccc09588610a3b07c865d0ed3e58c2d2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ede89b34992d0ff274d65a2633da95fc9f4bf2917cbb3c435c3e0ed3c12543c"
    sha256 cellar: :any,                 arm64_big_sur:  "9448d1aad08edf28f75506c4ff24af2ec937962d1d4913f0dfbcc047b237e77e"
    sha256 cellar: :any,                 monterey:       "96c8717f1fdca399574e5f25b37959062d075e52704a06488c3fcc909dc1baa1"
    sha256 cellar: :any,                 big_sur:        "bacd5286364629a6f0cab6553453f1e72c1fa9d32a8a027df8bb28a5c1391c18"
    sha256 cellar: :any,                 catalina:       "7fefec0412b5fd47cc02e263c02a4dc4d9abbde27063be6313326f819eebdc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d25ba1a2dbabf471ebe079236c2d1a24f3e9cec147e9c0669f3517cbabc639b1"
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
