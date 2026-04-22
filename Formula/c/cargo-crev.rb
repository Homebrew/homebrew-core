class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://github.com/crev-dev/cargo-crev"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "785ed01f3352331ac4f6ecd63da5ab896a4d251678ad75b6bcf1545858a4cc82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71e14ec0c42cdd3dfe446ece32f58d5f52ff6d31db25b3de1acc4a6a2dc1c5f4"
    sha256 cellar: :any,                 arm64_sequoia: "49a298d9684d31c5a47203fa980ed2ca90f43299a5156f6af8b39eb8d04719f5"
    sha256 cellar: :any,                 arm64_sonoma:  "698e6d52e95a6dd3efa9de309d77d6a492ca79842e74f90f85f964661b1af932"
    sha256 cellar: :any,                 sonoma:        "3ba1e65600f43c32a417998885ddee0406696577899cb185f5f6208f6489ec0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194d2633b70788c541c460d7ebefff409b90a41f921ca4e3bcb68ba68efb7f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75cc24c53306a0e7945e4a95488cd8bbf79d1aa1c7da85b66ca3dc2ed000f987"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    require "utils/linkage"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
