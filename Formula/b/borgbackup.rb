class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/93/87/98299ebfe41687f77ea01bd0e9eba2f43baa30f1b9256345134fd77286d3/borgbackup-1.2.8.tar.gz"
  sha256 "d39d22b0d2cb745584d68608a179b6c75f7b40e496e96feb789e41d34991f4aa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "daf7cbbfc026d568d82529fc82bcef3303e68dbf29946c219fd800e336c72bed"
    sha256 cellar: :any,                 arm64_ventura:  "27c50f3c2689567ffb5c96c7eb181134c4bdc88314098734bb4e8c2838ff9d80"
    sha256 cellar: :any,                 arm64_monterey: "a0c681111af7b1df4b2586db7dc476dc4c9ed219b21ab1421f27e6affe3a02ad"
    sha256 cellar: :any,                 sonoma:         "4b1bdf0a0f26c0425543d27fc37b1763fc976fa0c6649d1bbf38011ea4104175"
    sha256 cellar: :any,                 ventura:        "f119578a920668e951e1d420911937668ca828dbfbbd7b0e147472ac21aed0bb"
    sha256 cellar: :any,                 monterey:       "b4bd7cb80b54ba9c0de691f10bac08f389ba4368e021c5f4a7263f2cc2d6ea78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec31783c6e8da3502b9b35c2bc4fedeec7571d65b7b6f13c41b4bc01e55a3616"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

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
