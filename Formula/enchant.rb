class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.0/enchant-2.2.0.tar.gz"
  sha256 "2f91ea06992c923ac9b72c9c6d0a7c855aef1e9a4991350d83236723c8412467"

  bottle do
    sha256 "caf76a7a4dd20898b726a67e341e1d14cb398bb8209c150bb33239ddb3a07208" => :high_sierra
    sha256 "53ee18eb377da969936e416a08b3f64d85eb4553bbaafccf7dddce9a2965ef2f" => :sierra
    sha256 "663074bcc44168c80fe3e61ee053a717d50e1578f31e54cb64f252dd1b65cb37" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :python => :optional
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
