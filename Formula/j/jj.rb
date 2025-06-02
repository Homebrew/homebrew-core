class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "57df34a06b1d2125ccd6e8383ea08f24160c48e33e9daecd883a2e59567a9fd9"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50c511670ee40fa1da2d8b18029bad69223ee3d8e50a3009d4607ac94390fc48"
    sha256 cellar: :any,                 arm64_sonoma:  "5d6c168d37c55fdfcaaa4c95b3e380cc859296ef9d114ff5830ff8aa2291bbae"
    sha256 cellar: :any,                 arm64_ventura: "48f0c95193b1714f59799528db6ae6069148fdc21963dcf76c205f9b5b377579"
    sha256 cellar: :any,                 sonoma:        "33a01d5e4b4cd52ae2dcb1830288cbde9a9560f56c2205fb267140797ffa2d42"
    sha256 cellar: :any,                 ventura:       "62b3be14fd3c750708c27a70c1edea19c893a67cdd45154ea259583661459970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439cd35809f8b0eb10150b5598be56d1afbfa9aa5a2c26aecbd1dcaad1414a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2140f62549e58a6938ee9d265d926223bdfca139485464958e89340279f3af47"
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
