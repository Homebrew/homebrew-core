class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://github.com/borgbackup/borg/releases/download/1.1.14/borgbackup-1.1.14.tar.gz"
  sha256 "7dbb0747cc948673f695cd6de284af215f810fed2eb2a615ef26ddc7c691edba"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://github.com/borgbackup/borg/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "c04342b9fb9a2ae30e7030fafb7ac38ef68a8cfb0c6f095bd66926dd41240bc9" => :catalina
    sha256 "c0caa9585403c77102d7b9d31f38bbcfa9ed26e8b4a0893daa43e6fe2b03f6e7" => :mojave
    sha256 "572afe4f34d36ae32c0ec48da8d4a2e9cc59b4ad891f884e5a1efe48e69c478c" => :high_sierra
  end

  deprecate! because: "requires FUSE"

  depends_on osxfuse: :build
  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "zstd"

  resource "llfuse" do
    url "https://files.pythonhosted.org/packages/8f/73/d35aaf5f650250756b40c1e718ee6a2d552700729476dee24c9837608e1b/llfuse-1.3.8.tar.gz"
    sha256 "b9b573108a840fbaa5c8f037160cc541f21b8cbdc15c5c8a39d5ac8c1b6c4cbc"
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
