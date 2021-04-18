class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.7.0.tar.gz"
  sha256 "116749b2a6c95f6559439494fcebdbe803dff14037017ad239843c84c59d708e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe17a918d775bae8edc3979fd738e74facfe1f8973abdfcd61156d9d4a434c1f"
    sha256 cellar: :any, big_sur:       "d8c08675127341e5722cc32655264db3302452236b8cf0f2c50df3482c3aa4fa"
    sha256 cellar: :any, catalina:      "23f50861ba90e4741bb83ef2eb0528d5c857ae8d1de3b419c76ffb4605244b7e"
    sha256 cellar: :any, mojave:        "2c8b902da49a858e8c6ab479e63bf2138515ceb3d98c0ae4e36631bf06901c9e"
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

    on_linux do
      args << "-DUDEV_RULES_DIR=#{lib}/udev/rules.d"
    end

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
