class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.27.0/liblouis-3.27.0.tar.gz"
  sha256 "b3f1526f28612ee0297472100e3d825fcb333326c385f794f5a9072b8c29615d"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "a81eea7d4800706fd8a6b41c3ae254acbd444cdf9424bfe65a16358f6ae01686"
    sha256 arm64_ventura:  "7e970b0edb98af8e3a7b03cf3ed95848c0f8ee9eaa501b3fa5a227edd4fa04d4"
    sha256 arm64_monterey: "5a8536e0073325a8f9e8a95044a7453d9c03bab9281de1cfcf089789a4715b49"
    sha256 sonoma:         "32e6ba5134dc11c832d9639bb1871e6c9ba854262184b6d5c9168d09f8bb0898"
    sha256 ventura:        "9898201b9f21fb473ee63c4b5a2df4afd928ef86c907c85fca2d4932e2041007"
    sha256 monterey:       "ae00b24333293c97c2815ce7590d2f58d9a3b693bbf52d9ed355a0e68d3b8597"
    sha256 x86_64_linux:   "4784b929e8e42d0bd1c3de30de2373aabe51699db2cf15c9efcccabd7de46f2b"
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
