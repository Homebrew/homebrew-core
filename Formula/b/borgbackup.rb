class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/62/5b/aec6c069840f64f744d661c5eea1c648d407bebb836b2e12d8a3b9939bb4/borgbackup-1.4.5.tar.gz"
  sha256 "4f9a5fe584c504b15485841236750dea16aa7cd2ddbc4a594e9d2ce5c49c4508"
  license "BSD-3-Clause"
  head "https://github.com/borgbackup/borg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cef0d0124fdb140060100f61ea57c1bdf7d72d80d9cf25e3bd22f42e7947cbea"
    sha256 cellar: :any,                 arm64_sequoia: "af26aae2b9e0afda3078aa9f469c8525cfcaf6b50b6a803837d64d9709b14c6f"
    sha256 cellar: :any,                 arm64_sonoma:  "20a80495a3bba5d35382d3d85187601ea60cf590cace21da85201fcf860b7790"
    sha256 cellar: :any,                 sonoma:        "a2a8796545d9be4e01d4d13b717cafce8ffaa1d40fff5d9d4b6457333aa3221e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8799c68b83b8490a5aba4b30839b81a3962e95d8e11a440765c9f58174b70d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e655e9ba03ae174b79acfb4bd8de8deb6408c77430b58a84ce252d9dbcdf5656"
  end

  depends_on "pkgconf" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "python@3.14"
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
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@3"].prefix

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
