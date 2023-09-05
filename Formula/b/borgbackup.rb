class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/cd/a2/d4375923a8b858312e6f4593ac7f613d338394f3feb669f67d2a6269d2f9/borgbackup-1.2.6.tar.gz"
  sha256 "b7a6f8f086039eeec79070b914f3c651ed7f3612c965374af910d277c7a2139d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c9cb732df27f4a87342c39b7f4de834dd53c252b3a2c0888cce02cf507d93a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bf97ca6db8d2a536ff41040c01a584a80fec46ceb0c5fe627a4bbdb296433d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a5eb195a3d26ed1f7923413d82b93e3d75c3826c1dc51c9add61b0daa89b601"
    sha256 cellar: :any_skip_relocation, ventura:        "3e0f49a545943651814fb75d6320fe8ef2d035b63a74e7225973ad01d39eef16"
    sha256 cellar: :any_skip_relocation, monterey:       "8add3eb524d579a4bea6a55e09728057123d5c4879ed966bc2a5eb5d649dcbc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e3832bc6484a7a347e9c87715723b72ccf5d83ecba15fec2d5664d878fe7271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d829fe8f25d6286444e2fb74b95996c99929e7964d11136f0705c6fa071756a"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
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
