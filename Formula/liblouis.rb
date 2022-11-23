class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.23.0/liblouis-3.23.0.tar.gz"
  sha256 "706fa0888a530f3c16b55c6ce0f085b25472c7f4e7047400f9df07cffbc71cfb"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "fc6537c67f337ed02502cb8af8ebbf110c8071e15762b89a8d0021e8330a466e"
    sha256 arm64_monterey: "2ff0dd1d1a33c710b7fdde2a1c49f4780d586f1ae29bd7283eed3471d0b948e3"
    sha256 arm64_big_sur:  "1e908e6a6877ef23418c0b5ac9fce615ec0181e2a8ca21cd5e311ea2398fb591"
    sha256 ventura:        "0a277e5e7313ef6e5a9bb6e026eca1e16a4f2ea295fa805bca168c87d9807563"
    sha256 monterey:       "dbfc4a7f7a8cc40ccf5afabb1f92ac2e369dd7f740ec3d4fba8ed915864dbc36"
    sha256 big_sur:        "0e4090d80ab6850d7d4418253f98eb8ba70c77d3959140b1eae8285ce28f1b40"
    sha256 catalina:       "c687424423fee672cb59c8253c9aa6550a4d0ccc334974955ed95141eba2c615"
    sha256 x86_64_linux:   "76dbac7a35969647c9da5bcbf2c51224ff5cbf459fd9f2b8b7fc153ae875bd39"
  end

  head do
    url "https://github.com/liblouis/liblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
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
