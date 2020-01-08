class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"

  stable do
    url "https://github.com/liblouis/liblouis/releases/download/v3.12.0/liblouis-3.12.0.tar.gz"
    sha256 "87d9bad6d75916270bad14bb22fa5f487c7edee4774878c04bef82833bc9467d"
    depends_on "help2man" => :build
    depends_on "pkg-config" => :build
    depends_on "python"
  end
  bottle do
    sha256 "90c614058cf9c41fff51ad7b37077b21719657eb516fefe5aa25903ca318fbe1" => :catalina
    sha256 "cc17c437f3250401f16dfe0c3121202fb38aea0db899ba1cef0fe08138a962a8" => :mojave
    sha256 "9cc3903c672c3939d50363093c4db8e64ccbab88b03f689c154dfaabc94ae161" => :high_sierra
  end

  head do
    url "https://github.com/liblouis/liblouis.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "python"
  end

  def install
    if build.head?
      system "./autogen.sh"
    end
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
    mv "#{bin}/lou_maketable", "#{prefix}/tools/", :force => true
    mv "#{bin}/lou_maketable.d", "#{prefix}/tools/", :force => true
  end

  test do
    o, = Open3.capture2(bin/"lou_translate", "unicode.dis,en-us-g2.ctb", :stdin_data=>"42")
    assert_equal o, "⠼⠙⠃"
  end
end
