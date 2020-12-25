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
    sha256 "8fa69d333e97788e86016cf4d69a18e2e423d5176a9117ef65c16a9455c8d905" => :big_sur
    sha256 "f9b5972744a1411afd6756135ea9d01fbd2e05b101a32a21e3be9cb0fc143ab9" => :catalina
    sha256 "20cae900b7f125016276497ff08d9d67d23c74cfb0bd75b643775b02e9696628" => :mojave
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
