class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://www.nongnu.org/avrdude/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://download.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    sha256 "c0ef65d98d6040ca0b4f2b700d51463c2a1f94665441f39d15d97442dbb79b54"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "65f5579c7b176fc78de91c1d309f4cb8e136a79972be313a2c3076475affc048"
    sha256 arm64_big_sur:  "a625b08467db77bbbff93599153251f16e3d15235c645343dce482e57abbc471"
    sha256 monterey:       "2932a8676423fa675b8da2fbcebfa2c152f6f87eed658227b9779a451373dd4f"
    sha256 big_sur:        "266ecdeeae11537c62840876282e08284dc7be8daee4d76d49517feb4d2b9a68"
    sha256 catalina:       "06862b3b1aca50a4153d1bf170c9c94772c9f11c6b0fd0b9afb542e087ef4740"
    sha256 x86_64_linux:   "af717b50bd15063d31c5f3aab0c455e691e9c43fc8ea4d127676c167a98ab881"
  end

  head do
    url "https://github.com/avrdudes/avrdude.git", branch: "main"
    depends_on "cmake" => :build
  end

  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
    depends_on "readline"
  end

  def install
    if build.head?
      shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

      system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
      system "cmake", "--build", "build/shared"
      system "cmake", "--install", "build/shared"

      system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
      system "cmake", "--build", "build/static"
      lib.install "build/static/src/libavrdude.a"
    else
      system "./configure", *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
