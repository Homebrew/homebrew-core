class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/de/79/2031c715a35c1fc943cdac83337b0070737d29796270454bedf52d2ac457/borgbackup-1.4.2.tar.gz"
  sha256 "8923f5e953205d81138d1d7276c8a1c864215e230994d620c397635568ed376f"
  license "BSD-3-Clause"
  head "https://github.com/borgbackup/borg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dcad2aa0003c6fe565a572ab227d39088b2e6d214ea67dc1cf8c86debe9aeb3"
    sha256 cellar: :any,                 arm64_sequoia: "56f1467b3cdf858045d4286e5334db90f694b399d2deece026a1e0acb2c0596a"
    sha256 cellar: :any,                 arm64_sonoma:  "4c96af8b2bd0ea5eaf4bb006d5af725bb4b4bd8073cb7f95e769666363b73f0f"
    sha256 cellar: :any,                 sonoma:        "7e6d496de1ac2536d58c5282b681d91830b312318a54eb1eb6ad082285765c69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c86363324b95da0c1c1a19b88d388894c286587261a218909eb940c6003ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69525cf2f1f65c56f6f078a65252ef56473918e8246e62e07f09f95b2980b7d7"
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
