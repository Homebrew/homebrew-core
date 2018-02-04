class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.2/enchant-2.2.2.tar.gz"
  sha256 "661e0bd6e82deceb97fc94bea8c6cdbcd8ff631cfa9b7a8196de2e2aca13f54b"

  bottle do
    sha256 "bfd5c8794d5983d683474998cca0a661763063ebd9b6d4ff23a769c3cb422559" => :high_sierra
    sha256 "92a11886e596d37f6510fa328fcfc7db8e7017a393f838cb7baf8eff29f948bf" => :sierra
    sha256 "07a3df2729cbfaa080d5c38576a93efa8823ac0770c8131675b10fc1197ac01a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/9e/54/04d88a59efa33fefb88133ceb638cdf754319030c28aadc5a379d82140ed/pyenchant-2.0.0.tar.gz"
    sha256 "fc31cda72ace001da8fe5d42f11c26e514a91fa8c70468739216ddd8de64e2a0"
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
        inreplace "setup.py", "ez_setup.use_setuptools()", ""
        ENV["PYENCHANT_LIBRARY_PATH"] = lib/"libenchant-2.dylib"
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
