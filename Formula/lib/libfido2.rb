class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/refs/tags/1.17.0.tar.gz"
  sha256 "ace062d14a482ff9325410ff63d06c8b5fe87e79ebc18dda07add2bc0188c77f"
  license "BSD-2-Clause"
  revision 2
  compatibility_version 1

  bottle do
    manifest_sha256 "f976501d26cfc868d8c92fcd4098a347708464aead2b3aab7742382d75e189bb"
    sha256 cellar: :any, arm64_golden_gate: "6407a5715cc67b0c0acf715ba34c8c15001e6f2b49959477ccf4dc08d4c27020"
    sha256 cellar: :any, arm64_tahoe:       "9612687aaa341d338f0f71a18a45e5399ecb2a5cd04664ee0f9e04dcc9460aab"
    sha256 cellar: :any, arm64_sequoia:     "cd56a071ed3cca968ac12a94cd8f9e9b73ded9a53f68a9439c1173e8c3fd6212"
    sha256 cellar: :any, arm64_linux:       "af3ca0a6bd18489865e7a492011917fb913baa90cafd2a07d48917b1c8b0cd5c"
    sha256 cellar: :any, x86_64_linux:      "7c3b0fc7503c444499d5ebdd2584512ef2a93d3e4f5193fd0211394109510afb"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libcbor"
  depends_on "openssl@4"

  on_linux do
    depends_on "systemd" # for libudev
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
