class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/a6/19/f94be9fda92ea73cbf22b643a03a0b64559027ef5467765142d8242e712a/borgbackup-1.2.7.tar.gz"
  sha256 "f63f28a3383c041971cec87b061ca39a815b5fd445db24aa8172cac417d9411a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7100fa9d7fc8f028649ae0d87ac0f43261fd29bec22559c766f75fd8397bfc98"
    sha256 cellar: :any,                 arm64_ventura:  "7eea2d82869e8aef5b24d5c916962fa5fdbef89f4792351bbbb01e8ac1e727b7"
    sha256 cellar: :any,                 arm64_monterey: "f0ca05757191f1c0ec833c54cb03d27bb83151ccefb1befd37dcc1452b8a3987"
    sha256 cellar: :any,                 sonoma:         "26b49cb0d0da9ebc32530289853f7d7a8cab0221f20b37334ad9c4b293122d98"
    sha256 cellar: :any,                 ventura:        "e6656f7e859696ff3a0ce5c8e8cd7a4ab36ee7d1f3fac66ec36927facca27441"
    sha256 cellar: :any,                 monterey:       "671e11f2a190941b2743f328f99763f2f22a39db1cf0b403f687c5c6941eb64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52132ddbb9b99149a2c7868bb3a2ddb5485ddc35b82a1ed0cf12e0eba26732c4"
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
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
