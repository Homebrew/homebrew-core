class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/d4/49/7f35a26124631ec87ee7467ae42b52c1381eb82c564108652dcb5edf99b9/borgbackup-1.1.16.tar.gz"
  sha256 "bc569224d6320483e508c36ff2a651d01bbd0aaebf32305e2683a696b9c32d50"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1f09de37b5fe3241769883419c428101d33527d69a12fb87dd04d9a58f46e642"
    sha256 cellar: :any, big_sur:       "ee9ea1c3ed3f90c2eeeed0b94d39045798c346b44a86f44cd23d2d1df071246c"
    sha256 cellar: :any, catalina:      "bd51e4780ef2add38d62ab7ae288ae0c667520c86a7c271abbd380333b8ed029"
    sha256 cellar: :any, mojave:        "f623b6ba4c9606d1b89bc1195ad0dc12695d126f37d47446e27f3c5f66b02fc0"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "xxhash"
  depends_on "zstd"

  def install
    ENV["BORG_LIBB2_PREFIX"] = Formula["libb2"].prefix
    ENV["BORG_LIBLZ4_PREFIX"] = Formula["lz4"].prefix
    ENV["BORG_LIBXXHASH_PREFIX"] = Formula["xxhash"].prefix
    ENV["BORG_LIBZSTD_PREFIX"] = Formula["zstd"].prefix
    ENV["BORG_OPENSSL_PREFIX"] = Formula["openssl@1.1"].prefix
    virtualenv_install_with_resources
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
