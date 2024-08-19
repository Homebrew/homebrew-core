class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/dd/0d/28e60180ce4ae171adba65ce9f8878fce3580c6d2cfdfa998929175105dd/borgbackup-1.4.0.tar.gz"
  sha256 "c54c45155643fa66fed7f9ff2d134ea0a58d0ac197c18781ddc2fb236bf6ed29"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7bfd8881fa3546f8effad205346aa78da12f9a9ec7bc0cb2ff566c93a798ac7"
    sha256 cellar: :any,                 arm64_ventura:  "055cbe7be0447046b1755395f3a3a76b8ba99ba6cbeecb33ec2a013c9c5d9d63"
    sha256 cellar: :any,                 arm64_monterey: "253d5ada3336930310dadd2f9462984df0d661fa53f31c10120d40aa6e16ef68"
    sha256 cellar: :any,                 sonoma:         "0acc28647161578f2f5e410e91cacd86efc8526e7428c5829f90e9725d304320"
    sha256 cellar: :any,                 ventura:        "af265bcac6b0ab45247f15ecd2f3e8ed5f681e09ec5be3a22c8651f5d1e2d24b"
    sha256 cellar: :any,                 monterey:       "b1ce3fce36603971bf5bc74c4a8bcd059429269c9cfceec13a99f731642362fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536671fbfb5abcf19e5ad7ddb383bf5cbb26c2553f114aa96f50bd448a950cfc"
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
