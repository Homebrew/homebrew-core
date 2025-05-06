class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.16.0.tar.gz"
  sha256 "7d86088ef4a48f9faad4ff6f41343328157849153a8dc94d88f4b5461cb29474"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc3ca624819563b43e5ddc18ea7f391df1573e4e392a8a49c6aa3a510973f4dd"
    sha256 cellar: :any,                 arm64_sonoma:  "763d62c0d6240560ccdb3249477b7461e941454d8b4697a0d14a4d174eb9a6c4"
    sha256 cellar: :any,                 arm64_ventura: "64bd12fd3d3f964e781ac631f6f8dae04be4736111e857f17fd65a3cfe37c132"
    sha256 cellar: :any,                 sonoma:        "2bd458622e779d77c7ae6c359d29223a070ebbb89fcf0324db7671ac30ce8aa5"
    sha256 cellar: :any,                 ventura:       "c8a44132a8e43fb1dd859cf5f17192a453711ff251f12571bf0e926b86c60fc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85e993e3403b124faafd3ab0c1a16ff9b494f54766f504e90e83bf62fe40675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98507976bf7cd461abce2639656bd4456c0e2f52fee5bcd384a7cbec474a28ff"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    args = OS.linux? ? ["-DUDEV_RULES_DIR=#{lib}/udev/rules.d"] : []

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--build", ".", "--target", "man_symlink_html"
    system "cmake", "--build", ".", "--target", "man_symlink"
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs libfido2").chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-o", "test", *flags
    system "./test"
  end
end
