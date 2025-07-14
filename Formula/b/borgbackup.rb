class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/d3/8b/f24d8ab37b8d8cd85a55fa6cfaf98754bb7b6c7534c03ffe087506080a53/borgbackup-1.4.1.tar.gz"
  sha256 "b8fbf8f1c19d900b6b32a5a1dc131c5d8665a7c7eea409e9095209100b903839"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c79fdc448cb708b9508b0860965a57921a1698f951efd0eea11272509949085"
    sha256 cellar: :any,                 arm64_sonoma:  "6cf7a454cf9b38e348594a6965c07c21947cbb2d7f9cc737a4289032898d2d7e"
    sha256 cellar: :any,                 arm64_ventura: "c1a05f137139afdb6252f12d3408a6f8b6924bded32c81c21fd913b5a00352d6"
    sha256 cellar: :any,                 sonoma:        "efa12e14fae859240c6b9c6878246d757e8ee756a0bac43ce22bc1f8c21b5ba9"
    sha256 cellar: :any,                 ventura:       "cd24f51bf718fd2d4b2ff427972b35ec6c40c946e544f5884aaafee30fe9c5ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8f9a96fb57c0342d32dc41591d53b22342ac0086a67d4ed6aaaf80451ec301f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1de924be5f22308b7414f2a70173315d2d33f116564d734ec9ae5b75741fdec"
  end

  depends_on "pkgconf" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
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
      system bin/"borg", "init", "-e", "none", "test-repo"
      system bin/"borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    end
    mkdir testpath/"restore" do
      system bin/"borg", "extract", testpath/"test-repo::test-archive"
    end

    assert_path_exists testpath/"restore/test.pdf"
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
