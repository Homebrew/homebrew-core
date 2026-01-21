class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/7a/5a/090ad33133d34d71aba70e40eff030aaa3a07776fa38cc8bd85eb856456b/borgbackup-1.4.3.tar.gz"
  sha256 "79bbfa745d1901d685973584bd2d16a350686ddd176f6a2244490fb01996441f"
  license "BSD-3-Clause"
  head "https://github.com/borgbackup/borg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d07a33bc5d32d39b5186bcc5d0a8513296d73c937bb76c4e0996c89af36e7d64"
    sha256 cellar: :any,                 arm64_sequoia: "42f429e008f9b77a1b0f3e53fbed0464936e587f1bcfec1e1b65c5ac9cab2ac5"
    sha256 cellar: :any,                 arm64_sonoma:  "704d2dd23fc9fe452978726edf6d0b5274558519cdcecc864d43caf534d956d7"
    sha256 cellar: :any,                 sonoma:        "02db69674ba7789ec901cffb9099e68e5e62e3c361d99193f51e17e054382f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9105767b33dcc8e4743a9f4b71e07f0af75935a0d40f43b33bc0e14f58257a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53150306ad352ba88a313abddf7b29a2147f57b4271a99c1e908402bcac1bf5"
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
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
