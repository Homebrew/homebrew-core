class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.9.0.tar.gz"
  sha256 "ba39e3af3736d2dfc8ad3d1cb6e3be7eccc09588610a3b07c865d0ed3e58c2d2"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "599d48182dd42d72a78f197c53ef50c766abd75eeec93d4632c4f556f502baa6"
    sha256 cellar: :any,                 arm64_big_sur:  "c0d26a6b4ad524140267c476891a2eb662c246f207f7bf91a3663de0f6ed2bb3"
    sha256 cellar: :any,                 monterey:       "78928cd0a6cd31e2761f30b413e08e543a998051b290bb62cdd3b26016f58fcd"
    sha256 cellar: :any,                 big_sur:        "3d7b20b6e5e2a025761e840d612610fede420619e40ef90a657de46545cbaebe"
    sha256 cellar: :any,                 catalina:       "cd405fd77e328489c41789ec3ac6eecec75e67784729d5d10e9afd9de8c8b54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f6e1e3da72a1601746322fd0b229d33f2c0056e774d52c4f86c688c7d98ef73"
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
