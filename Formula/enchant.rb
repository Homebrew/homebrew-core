class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/archive/enchant-1-6-1.tar.gz"
  version "1.6.1"
  sha256 "ed2b11211a571ab5f963debf4c3bf3fc46541bb9cbb441b2997bd871ba8618d4"

  bottle do
    sha256 "22fe912e6addc1433750e5da08691be6ec4c721ac91e150b7d5a64b7637d3c19" => :sierra
    sha256 "bbe368cbefd64aed845d98198d6f49fd533bc058b62290414865cca1ffdcc8cd" => :el_capitan
    sha256 "0315d7b75f8bcae0196e76c192cb514d723fd79df6f043c7ac13b3289d018b14" => :yosemite
    sha256 "622f8b9b8f008eab4d689c6b39c00887c803fb49b5ec461b7fe520737f179427" => :mavericks
    sha256 "35e3487d842e8b4be3e4dfa6d7c34a48c17bd875871da738733cb9305585619c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on :python => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://files.pythonhosted.org/packages/73/73/49f95fe636ab3deed0ef1e3b9087902413bcdf74ec00298c3059e660cfbb/pyenchant-1.6.8.tar.gz"
    sha256 "7ead2ee74f1a4fc2a7199b3d6012eaaaceea03fbcadcb5df67d2f9d0d51f050a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-ispell",
                          "--disable-myspell"
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
