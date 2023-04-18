class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https://developers.yubico.com/libfido2/"
  url "https://github.com/Yubico/libfido2/archive/1.13.0.tar.gz"
  sha256 "51d43727e2a1c4544c7fd0ee47786f443e39f1388ada735a509ad4af0a2459ca"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b5d3c0959fed640408631f685d51ec26704455241ef6e04d375514d7b941563"
    sha256 cellar: :any,                 arm64_monterey: "c881e6791d6ee3e3f2b4c1f4f83ece33119522a782d6e47473f388144744d52b"
    sha256 cellar: :any,                 arm64_big_sur:  "01acb36bc6fc4090efd2b4a3d4466a317e7590b330255bc8e0608d1adde5a828"
    sha256 cellar: :any,                 ventura:        "73b745804c6746c64cf6d893d6ce79d8dcdcd61b12d0dc1ea661e44bb8df7821"
    sha256 cellar: :any,                 monterey:       "cf58469b1f43448949602faeb760108b13b4ca9749ab4c1d2ba054d96c602182"
    sha256 cellar: :any,                 big_sur:        "6bd137a882ad45647044ba1cc6f4c9ac582a2d0383e7ed7d071ac9acde3d38d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98b05a5da57c807f92bf4a689991556fc25b58df95de4a065368bfde80d35fc6"
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
