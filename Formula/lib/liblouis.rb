class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.io"
  url "https://github.com/liblouis/liblouis/releases/download/v3.29.0/liblouis-3.29.0.tar.gz"
  sha256 "4e73d86bbfe1a9af5447b3ddd607243b50414989ec290bfb467b9b774675c8f5"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sonoma:   "3f87adb7917c5328fa5e502408a13a68c645634050bf91bffb06da3c2535c0fe"
    sha256 arm64_ventura:  "f221985add2fadc846007485af8011be45e66612f27dfe458111bb5e231057c8"
    sha256 arm64_monterey: "6131bf73d147d49b4491b1787960373e5ecc710d100c2865d113bdc6a66c7675"
    sha256 sonoma:         "f460b16a919681f73eda7535ca5402998dbeff545a72f6a447a7b90b6101831c"
    sha256 ventura:        "17214faa6cdd3b62b1f09fe54177a3266a7314a8a66e08da8dac815adad64bae"
    sha256 monterey:       "e51e2723b138c8cc70b102225862d3309fdd7e03d058b25e8de5aec3e0fa5361"
    sha256 x86_64_linux:   "be73583ebaab7fa6c85f59b0da586045e2e6dfc27468a55d369914e664d0c6f9"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args, "./python"
    (prefix/"tools").install bin/"lou_maketable", bin/"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}/lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath/"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end
