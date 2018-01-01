class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.0/enchant-2.2.0.tar.gz"
  sha256 "2f91ea06992c923ac9b72c9c6d0a7c855aef1e9a4991350d83236723c8412467"

  bottle do
    sha256 "8b3c17db85400aea13290b60e0f295b0ab99a07556d73298b2d15ca49b23a8bd" => :high_sierra
    sha256 "cf488f0ef7499f27d7e423570e6edf9e00a95831a8ca39124b86534d4285eaa1" => :sierra
    sha256 "8ab702793bdb0ec411c91ea2f77375b896a93ae29297635af8f550ed2bd37da6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/source/p/pyenchant/pyenchant-1.6.5.tar.gz"
    sha256 "623f332a9fbb70ae6c9c2d0d4e7f7bae5922d36ba0fe34be8e32df32ebbb4f84"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"

    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"

    if build.with? "python"
      resource("pyenchant").stage do
        # Don't download and install distribute now
        inreplace "setup.py", "distribute_setup.use_setuptools()", ""
        ENV["PYENCHANT_LIBRARY_PATH"] = lib/"libenchant.dylib"
        system "python", "setup.py", "install", "--prefix=#{prefix}",
                              "--single-version-externally-managed",
                              "--record=installed.txt"
      end
    end
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text
    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
