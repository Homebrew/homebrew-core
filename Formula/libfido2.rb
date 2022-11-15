class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.12.0.tar.gz"
  sha256 "813d6d25116143d16d2e96791718a74825da16b774a8d093d96f06ae1730d9c5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1693534c09d366ff8c420e11fe483ce3ad4453d7864975b91585c559df881614"
    sha256 cellar: :any,                 arm64_monterey: "2caf7758a5816420678d11fb81f0bef74837e12539c4c8be6d074d1a5b074d51"
    sha256 cellar: :any,                 arm64_big_sur:  "a7cf0ef4f36cce15ab3b26b5681580d5af122b547f9b017ff7fda022517a0d2c"
    sha256 cellar: :any,                 ventura:        "273a33cef92fcf44eb3661355becfa69477f92852d7ded6240577ebceb847374"
    sha256 cellar: :any,                 monterey:       "130062c883742f34580c1ca5c63dca5215dae1ed6ff79c0f638be73daffd6ebf"
    sha256 cellar: :any,                 big_sur:        "756ac14a01eb7e2162c100cc0b2ec6c310b33d00252f1a04144dd1d2f9a8b920"
    sha256 cellar: :any,                 catalina:       "b7c9d561152606201046daf4c55aa743ada5c8f4fad36c27edd2e7964d897a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e518efa37cf76abee49f01988fe40a61396d207cf3b66fd62edc3e5f5d9847fd"
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
