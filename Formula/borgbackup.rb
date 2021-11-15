class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/c9/a8/7ce46b3ea57895164774644164089b63e0172ac72046f5fbbba5f135d7bb/borgbackup-1.1.17.tar.gz"
  sha256 "7ab924fc017b24929bedceba0dcce16d56f9868bf9b5050d2aae2eb080671674"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "4374bd33d19ce72e29804577264915015c7394a5212cda62425cc488f236a5f2"
    sha256 cellar: :any, arm64_big_sur:  "3d823d3a5b30435f09cf44be79f3aa2267fa80a59c099820913ae673f0bf597f"
    sha256 cellar: :any, monterey:       "559cc614a1e4881bdb6789f6312ffc68eadfecdd378c681f8be40df44d4b2549"
    sha256 cellar: :any, big_sur:        "0645cde1b652a418625603b783feb35af47ba987904b7f71604ea429d2eae246"
    sha256 cellar: :any, catalina:       "4cd0fd62d3dcdd6df8d7cb27e913b0d1e1964814eeb95f0214afdb6687d639a3"
    sha256 cellar: :any, mojave:         "9722b73c2e68d7d88161c57639044884dea3f7db0c4f5643a9a6b2d9d3c2b3fc"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "xxhash"
  depends_on "zstd"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

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
