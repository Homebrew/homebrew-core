class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.13.0.tar.gz"
  sha256 "51d43727e2a1c4544c7fd0ee47786f443e39f1388ada735a509ad4af0a2459ca"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca05400dc7dd0481f41f2553fdf4f61a7a6e83b93d24cf75da9f466ab55b1ccc"
    sha256 cellar: :any,                 arm64_monterey: "fc615aa6445386028c82143d7ca76da7e0d4ed4864362cad44c02400a6a8d6d7"
    sha256 cellar: :any,                 arm64_big_sur:  "51bb36596d2a20c4fcbeb987215caa601e642ea75969890c12ecc295c549a715"
    sha256 cellar: :any,                 ventura:        "6dc984c005f51e980e86adce21c21d204691d3ebed85882070e2ce4334ab618d"
    sha256 cellar: :any,                 monterey:       "9ee46084c9843396ee98d7ebf66e19a7e90e0f85ef7aed5e6dfe52c7ff0c126d"
    sha256 cellar: :any,                 big_sur:        "ea43b9c95bfc1f2452bf1d6e7de8efdb1861f2be94c385e5c0265070d6cdc22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb31ba31a74cf54897d36af23acfce66e450df700a6a0eaa357f041f03704b16"
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
