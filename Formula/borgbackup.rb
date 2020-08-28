class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://github.com/borgbackup/borg/releases/download/1.1.13/borgbackup-1.1.13.tar.gz"
  sha256 "164a8666a61071ce2fa6c60627c7646f12e3a8e74cd38f046be72f5ea91b3821"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "dd71d53fa665ec83d2f68a1b353ffcabaf499c83681ad0ce3a78eef3f3c79c18" => :catalina
    sha256 "f903ca24436d27d5f218b7bcdaf757a99a600c45bfbb63c9ab235ced12d8f2cc" => :mojave
    sha256 "6bc8fd5091f705e9843a77d3f87cd7b722b84243a68e99d8d15d8f8ae20d0b03" => :high_sierra
  end

  depends_on osxfuse: :build
  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.8"
  depends_on "zstd"

  resource "llfuse" do
    url "https://files.pythonhosted.org/packages/75/b4/5248459ec0e7e1608814915479cb13e5baf89034b572e3d74d5c9219dd31/llfuse-1.3.6.tar.bz2"
    sha256 "31a267f7ec542b0cd62e0f1268e1880fdabf3f418ec9447def99acfa6eff2ec9"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use `borg mount`, install osxfuse with Homebrew Cask:
        brew cask install osxfuse
    EOS
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath
    Dir.chdir(testpath) do
      system "#{bin}/borg", "init", "-e", "none", "test-repo"
      system "#{bin}/borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system "#{bin}/borg", "extract", testpath/"test-repo::test-archive"
    end
    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
