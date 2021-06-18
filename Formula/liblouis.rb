class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.18.0/liblouis-3.18.0.tar.gz"
  sha256 "21cca316bad6e4c7118c01cdf7278428c44848a81990572a56b4e5b47dd3aca5"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_big_sur: "c3c9966db84991a66cc3df8e8f56317f6ce10a7cf045fdecbeeb6738ca9e5aab"
    sha256 big_sur:       "85c3c273217223c53af7ccb21bd0831f6e1e4ae866e9f3c70b629ddd22f2bd92"
    sha256 catalina:      "a6e1f0c24d9a5dffc1c704ef971e509f6d8a877b0e194f5c7363754a9ae6d87d"
    sha256 mojave:        "594821b1fa5277a7e841c13ce4041c3642309dab7d0b74ca7e741f49398f0358"
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    cd "python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end
    mkdir "#{prefix}/tools"
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", force: true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", force: true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", stdin_data: "42")
    assert_equal o, "⠼⠙⠃"
  end
end
