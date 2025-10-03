class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://github.com/crev-dev/cargo-crev"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "9bf1ec351c15243c598db86b8edc292fb36b9deb8c4e94dd5506abf3edd5a41a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c2058bf99742c715b0715ec0c960c94aca85b3bafaa122669c43eea9420515a"
    sha256 cellar: :any,                 arm64_sequoia: "42cb4daca9c8d0ba31bf64d356570a0f8cfaeb29d0d49ba0bfc589edc5e2f97d"
    sha256 cellar: :any,                 arm64_sonoma:  "ff054705742a50eee0d2a398b38bc2878df9416e4794b3d918ded10b1fe3164a"
    sha256 cellar: :any,                 arm64_ventura: "3da7ac06e686b48d9bd8f5dae16a3e0a73a0ec5f7ab1400598a83b03a7ee5800"
    sha256 cellar: :any,                 sonoma:        "b02ac8662057a7042863e0ecd62a066c4f2bad9497f3761323b63b3fd46664e5"
    sha256 cellar: :any,                 ventura:       "daa86a9f52d84f32cd2f88daefbc642c1d1fbf5926027f292f30a794c967d8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ada93a107cf7b62feb2a4e7c18dfc667c2f37e7e65fcd377b4844d61a3d44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29aea144a97853f74044bcb0b34d684ca20719eb25bf5325731ef19b7a75ed55"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
