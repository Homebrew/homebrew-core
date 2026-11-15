class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/62/5b/aec6c069840f64f744d661c5eea1c648d407bebb836b2e12d8a3b9939bb4/borgbackup-1.4.5.tar.gz"
  sha256 "4f9a5fe584c504b15485841236750dea16aa7cd2ddbc4a594e9d2ce5c49c4508"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/borgbackup/borg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "05a9cc854e2bc6b0d8c3b538005183af2fe945089d8d48d140c5271ade7b71c4"
    sha256 cellar: :any, arm64_tahoe:       "19316a0d35fdf740fa189c58662e56d6fb77f1cbccc5a5a97f9e6b36893cd608"
    sha256 cellar: :any, arm64_sequoia:     "909a4356fd646a2646376586d73b698ddd3f834a93688022e9a4f5445d16a701"
    sha256 cellar: :any, arm64_linux:       "b66826caaaff982a458aaee68e4399e7471231fcf88efe4629a06326d1a9da52"
    sha256 cellar: :any, x86_64_linux:      "3cf6acdf1f1829988ecd76440b3a4d768c3e58c2bb1f8a0d4ab3e3ffe0404f56"
  end

  depends_on "pkgconf" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = formula_opt_prefix("libb2")
    ENV["BORG_LIBLZ4_PREFIX"] = formula_opt_prefix("lz4")
    ENV["BORG_LIBXXHASH_PREFIX"] = formula_opt_prefix("xxhash")
    ENV["BORG_LIBZSTD_PREFIX"] = formula_opt_prefix("zstd")
    ENV["BORG_OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4")

    # Parallel cythonize needs POSIX semaphores, which the Linux build sandbox denies
    inreplace "setup.py", /^cpu_threads = .*/, "cpu_threads = None"

    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath

    system bin/"borg", "init", "-e", "none", "test-repo"
    system bin/"borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    mkdir testpath/"restore" do
      system bin/"borg", "extract", testpath/"test-repo::test-archive"
    end

    assert_path_exists testpath/"restore/test.pdf"
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
