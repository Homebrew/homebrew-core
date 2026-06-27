class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/eb/38/7fc8c8c7d9dba455f0e29f2ab5b77109313f4e58fe5014d0e1b7855de3cd/borgbackup-1.4.4.tar.gz"
  sha256 "2716bc124a24908efcac9436df31b716d1f0bbd828ad39b18f73bfdd772a651a"
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
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
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

    system bin/"borg", "init", "-e", "none", "test-repo"
    system bin/"borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    mkdir testpath/"restore" do
      system bin/"borg", "extract", testpath/"test-repo::test-archive"
    end

    assert_path_exists testpath/"restore/test.pdf"
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
