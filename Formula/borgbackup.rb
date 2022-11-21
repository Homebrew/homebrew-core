class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/a2/98/479f364b69182b9a29c82607a17a9cf2e3cdc8743bb9570a4da9d511d0a6/borgbackup-1.2.2.tar.gz"
  sha256 "d730687443f1beb602b1d72bae36318f6f9654818fcdc50458540ec579e57260"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f468dbf559ebec00779a1242708dfe800583250381d318ff98c75a3be8dfa675"
    sha256 cellar: :any,                 arm64_monterey: "f3ce53018f86bf63b5a410174903398cd0bdba587041c5adf42bb5eecdc4cf4a"
    sha256 cellar: :any,                 arm64_big_sur:  "9e847d6ecd68963b08ccd570aa7a453768e877968c24a30c0629c5b582c95129"
    sha256 cellar: :any,                 ventura:        "e00acda76abf3dede13c50eeab7d5d952d6027327b2da777e6fb6a453de92aba"
    sha256 cellar: :any,                 monterey:       "0afb0588f8fd8b23a3bfb82c805198e954f607f3b0e7c9a05cca3e2224aeaf73"
    sha256 cellar: :any,                 big_sur:        "f94830c06a982822cdd602117c1bc9d59f06ee90791f6902d9104c8696c602f1"
    sha256 cellar: :any,                 catalina:       "a19d8cbc9245f083ae5ef585dd6f7701c247a342cf3031a9df28d5b2c8fb2fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ba6bc28c2d4e455863168703c85650c4a98748ea241da87416d81152850f17"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@1.1"].prefix
    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
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
