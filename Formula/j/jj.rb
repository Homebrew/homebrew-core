class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "dae80d2629a9f430a9ea795c8cd378ced6ce1c870ab9ffe3b61f64cdd636a2bc"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94cb7b6bd94ef185ad140d6697d5475b6577f192bf8a4e8a599acc504d61bbcb"
    sha256 cellar: :any,                 arm64_sonoma:  "ac72b0219e7cc311b02b2e8837e54cb3c6df9963a063e20e37f7a2aabdc7eacb"
    sha256 cellar: :any,                 arm64_ventura: "0a6ee059850461f8407e2065de7505e0b7971226cd715cadb44f2be992bd3185"
    sha256 cellar: :any,                 sonoma:        "f31c88e39a0d30ed5efabd04a27e8d9ce8a7f9f87cf43122dd8bfee3620894cb"
    sha256 cellar: :any,                 ventura:       "adcee265c948ff6f08a8b92578665ce2cdd1ebb2eadc4e8587fbade75250e0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be843c4b26b533c13138f5f3d5f455cb58ac4c7fe7a5890fe5cf84764379fb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805f70f61961c73de428e3d714fec32dbd1aef834081a70a2fef8a2b3689082c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    require "utils/linkage"

    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")

    [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"jj", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
