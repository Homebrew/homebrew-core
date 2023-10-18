class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.13.0.tar.gz"
  sha256 "51d43727e2a1c4544c7fd0ee47786f443e39f1388ada735a509ad4af0a2459ca"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c100334468bce64470a1bca586752453787ab2c45d38909dca80ffbd4943ccc4"
    sha256 cellar: :any,                 arm64_ventura:  "92ec60d842d0f283bf1d5f3e063aee439cbe1bfdb3b458556caa0dabeed3d0e1"
    sha256 cellar: :any,                 arm64_monterey: "ad03ed8928436cf37260a365287c0f5fc0b82379a31ebf59b2500e7ef04aa0ec"
    sha256 cellar: :any,                 arm64_big_sur:  "62bc2844dfe47bd9c5a05b61b4e8e6d4ca765c5ae15679406fa21f1c17aae031"
    sha256 cellar: :any,                 sonoma:         "8d6d367e54291b4b2d4f0eae9b86dacbcc1be3741f6cd41600a1bf6149028068"
    sha256 cellar: :any,                 ventura:        "e3f26a2f2a3ed809d521960ab19f6cd7165a6c8ef634dafec625f4574f692365"
    sha256 cellar: :any,                 monterey:       "965c77b9c1fa018c00421affc54cf9e291733a7f945044977c1118e7f984c060"
    sha256 cellar: :any,                 big_sur:        "fbc2977a46a8a2cd67003d6481c124407eb154f477f5b1bd558a71673319739f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a0268ea3f24f5d9f0c4bfbe997d425d7f2f133c4df6f8ebe8c87bf7e76372f"
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
