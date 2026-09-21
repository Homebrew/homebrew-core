class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.34.tar.gz"
  sha256 "ab790f39e53bee9570f17c58d22e4bc03246f25d45e12cc1b7b5f2bef6d14611"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "708587c2e972e69e470cd69015982e6349d417c9db4d14428d7bc8b86ae078a9"
    sha256 cellar: :any, arm64_tahoe:       "8f71679b731e4a7bfbcc382dd7f911d6f634ed37c9eee02143971226d2d451be"
    sha256 cellar: :any, arm64_sequoia:     "d8d437801b8ec655f19801fd9d83b80ff4f6fcd69a7d4de5b30bdb1c1d5b7e00"
    sha256 cellar: :any, arm64_sonoma:      "1fcf0c6c6101d4e067e7718305a9d57c5f00824ae0e08a72091794b2062638d9"
    sha256 cellar: :any, arm64_linux:       "0fe6a15cf51268dc23e3105263d170c93c23ff823b01911ac4c7e8c85bc295ec"
    sha256 cellar: :any, x86_64_linux:      "6fe2954a65d5c41aa658850b16ee0cda1fc1c0b6b615a30f6414c10127f94bd2"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.14"
  depends_on "readline"

  on_macos do
    depends_on "bash" => :build # config_cflags[@]: unbound variable
    depends_on "make" => :build # Depends on `make` >= 4.2
  end

  on_linux do
    depends_on "acl"
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_path_exists testpath/".bup"
  end
end
