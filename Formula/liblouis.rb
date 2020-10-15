class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  stable do
    url "https://github.com/liblouis/liblouis/releases/download/v3.15.0/liblouis-3.15.0.tar.gz"
    sha256 "3a381b132b140747e5fcd47354da6cf43959da2167f8bc598430bbac51224467"
    depends_on "help2man" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.9"
  end
  bottle do
    sha256 "5ec35e18d9de13ad40960d1866f7ceba11a44de71112b6d3efc368c405a721a2" => :catalina
    sha256 "cc2f0658ce034707db226a988ce69171b878d84a4208c25a630cb24315406874" => :mojave
    sha256 "08e0b675dfacb0911934caabb84e1cd19f2e91b5ffdb92c40861ace012f3f4e4" => :high_sierra
  end

  head do
    url "https://github.com/liblouis/liblouis.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "python@3.9"
  end

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
