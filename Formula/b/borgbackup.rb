class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/dd/0d/28e60180ce4ae171adba65ce9f8878fce3580c6d2cfdfa998929175105dd/borgbackup-1.4.0.tar.gz"
  sha256 "c54c45155643fa66fed7f9ff2d134ea0a58d0ac197c18781ddc2fb236bf6ed29"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ea0b6a39efabe6534d4c0d61ac53544ec56e7160c21a6c7554b9a5f1435d2f0c"
    sha256 cellar: :any,                 arm64_sonoma:  "913762693084b7db20b9dd17f8bf6ad44e9f1b558279126455d316b0d60bfcb4"
    sha256 cellar: :any,                 arm64_ventura: "8d180c48615881e8375ffec0da4b7f2489b88b13fa639934c24a48b07a395bfc"
    sha256 cellar: :any,                 sonoma:        "74a7a54445937d1553688936cdc131b58a64b8ebbee692a8bd1f284d8583f03f"
    sha256 cellar: :any,                 ventura:       "70cbbc7f8cace22332f240aeb6e8ad8036fe2f712b203f75534dd0253d80387b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b362ecca7e4b2d507ed33b16553b61db7d63124584b7d665533ef26971bd278f"
  end

  depends_on "pkg-config" => :build
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
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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

    assert_predicate testpath/"restore/test.pdf", :exist?
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
