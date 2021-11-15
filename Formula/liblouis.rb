class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "http://liblouis.org"
  url "https://github.com/liblouis/liblouis/releases/download/v3.19.0/liblouis-3.19.0.tar.gz"
  sha256 "5664b8631913f432efb4419e15b3c41026984682915d0980351cb82f7ef94970"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  bottle do
    sha256 arm64_monterey: "523882a8945fb690240b790162c0db3a6fff2b53f6ce6edb52c5332755f068d4"
    sha256 arm64_big_sur:  "fa9afd58b981aa8d297746bca152e8e073ef1d01159fc112bd30b407887328bb"
    sha256 monterey:       "5ea887b6b7da5615ec254b90b80136329017913f1818a8ae8f33a96ac266f398"
    sha256 big_sur:        "136591a6b53c1636d8854c7cc60949db3c2d67818c382124353d460ff460c546"
    sha256 catalina:       "089c1dd0bdbde0466a631f5deac55f8b608f7edff646ab848e2467aadf1cf552"
    sha256 mojave:         "7bef026745d51ac3f5329a4c985c1d98a89dc43dfe8460c874a7d83b95825889"
    sha256 x86_64_linux:   "db7173cf91c28efa928f6f32663a83157223d2b54a1983e2dbf0dd78d694dc56"
  end

  head do
    url "https://github.com/liblouis/liblouis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"

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
