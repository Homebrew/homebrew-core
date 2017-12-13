class EnchantAT1 < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/enchant-1-6-1/enchant-1.6.1.tar.gz"
  sha256 "bef0d9c0fef2e4e8746956b68e4d6c6641f6b85bd2908d91731efb68eba9e3f5"

  bottle do
    sha256 "caf76a7a4dd20898b726a67e341e1d14cb398bb8209c150bb33239ddb3a07208" => :high_sierra
    sha256 "53ee18eb377da969936e416a08b3f64d85eb4553bbaafccf7dddce9a2965ef2f" => :sierra
    sha256 "663074bcc44168c80fe3e61ee053a717d50e1578f31e54cb64f252dd1b65cb37" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :python => :optional
  depends_on "glib"
  depends_on "hunspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/source/p/pyenchant/pyenchant-1.6.6.tar.gz"
    sha256 "25c9d2667d512f8fc4410465fdd2e868377ca07eb3d56e2b6e534a86281d64d3"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"

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
    assert_equal enchant_result, shell_output("#{bin}/enchant -l #{file}").chomp
  end
end
