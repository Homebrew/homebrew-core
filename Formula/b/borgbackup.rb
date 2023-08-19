class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://borgbackup.org/"
  url "https://files.pythonhosted.org/packages/6e/9e/e7a116401ef0c6c2766e4e49e5a3aafaa725ba0ea827305f016339c6c496/borgbackup-1.2.4.tar.gz"
  sha256 "a4bd54e9469e81b7a30a6711423115abc818d9cd844ecb1ca0e6104bc5374da8"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a80057da725304e83b9e7da142aa27079b3b77e691886f2e2df3c5d5279d56ed"
    sha256 cellar: :any,                 arm64_monterey: "1e0103426f4cd4c7f433514ef828a32b0cebf7cae11ed526a7017d2c6a46cdb5"
    sha256 cellar: :any,                 arm64_big_sur:  "05f2643c635826b53bb6692e040dd2f5dd1e1c34bfad740340cf109e77488160"
    sha256 cellar: :any,                 ventura:        "3ce8161421a316a41699519f4cbada586d6194f70492ec5a5dbb6f4aec09fe95"
    sha256 cellar: :any,                 monterey:       "e2470014c09b792fa424738aac53189a5b9233071144495b7b0708cc68caecb0"
    sha256 cellar: :any,                 big_sur:        "3a8cc0298578af2d0815819ab805a364e113485c1036f313d03e23c5a926919b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350dc1537f9fe4ea846e61bbac8605997e41d7e3e581fc1e0b4369d2dd55be99"
  end

  depends_on "pkg-config" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@3"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
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
