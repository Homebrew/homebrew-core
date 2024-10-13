class Airspy < Formula
  desc "Driver and tools for a software-defined radio"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/airspyone_host/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "fcca23911c9a9da71cebeffeba708c59d1d6401eec6eb2dd73cae35b8ea3c613"
  license "GPL-2.0-or-later"
  head "https://github.com/airspy/airspyone_host.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6e66f0c2d5fe94466e432a57c49fdcf7cfb6a01f9d71896f74b06e9a3c16777d"
    sha256 cellar: :any,                 arm64_sonoma:   "8c086845772a91ed241283aa4175e0ba598e9e80530b660fceb413857211901f"
    sha256 cellar: :any,                 arm64_ventura:  "e32975089469cf19d14495a2ebfc86815aa431efeefaf11d24afd42e0fe8780b"
    sha256 cellar: :any,                 arm64_monterey: "9c2f5b4cc0c698d7f2690ea8091c8ce99b73ea659dc281916dbac0fb71ae3b05"
    sha256                               arm64_big_sur:  "3cebc54737172b116e3cdabc7770777954b6c1840940588cd29f431c4db526c7"
    sha256 cellar: :any,                 sonoma:         "522690a97cfed3979494776f031ca2ccad8c4240691ddcce9720636b96cb9802"
    sha256 cellar: :any,                 ventura:        "76cc6e04ec293907b1be68033f1725156ffd6bc7a6c0d95bd00477b78052bba0"
    sha256 cellar: :any,                 monterey:       "53843ed22a54472fe5d40ca9191f5425af68ab2996981c489ecd5b0cd8fae221"
    sha256                               big_sur:        "acada5e4e39e99dfad89cbcd1d0440cc3b4814936160b37220059cf602b94b4d"
    sha256                               catalina:       "5e8d910759443d83f3975b41e2805b4bfeb605d55271f0e37e8ca7de470415f0"
    sha256                               mojave:         "28e8a9afd6a78a3c091e70d0326431a68738ec26e08448d88d62974374a08a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1705571f2f7cc979706ceb8340ee737fde0b538002c3942145f35355b9b41d3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libairspy/airspy.h>

      int main() {
        airspy_lib_version_t lib_version;
        airspy_lib_version(&lib_version);

        printf("Airspy library version: %d.%d.%d\\n",
               lib_version.major_version,
               lib_version.minor_version,
               lib_version.revision);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lairspy", "-o", "test"
    assert_match version.to_s, shell_output("./test")

    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version --version")
  end
end
