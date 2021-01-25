class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/c9/4d/dd06d8787f8faa8c50a422abd9ba14be15ee0b5830e745033815c49d5313/borgbackup-1.1.15.tar.gz"
  sha256 "49cb9eed98b8e32ae3b97beaedf94cdff46f796445043f1923fd0fce7ed3c2bc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "0e44a5087964a741d4b08483ebf78537360be79f507e73561330a586d615a973" => :big_sur
    sha256 "74defaac235883c8c4330ac0f5618ca30d17ff098d88fa83f158c6f4fef518c7" => :arm64_big_sur
    sha256 "f5b616a9529e30fe7dab405cac668904f8e91b931540113bae52c70a2b182e8d" => :catalina
    sha256 "8e85f89b4e7b5ec8643ac7909aaccbf39efd02d9f3aa25bc3f45e897a62b6c58" => :mojave
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
