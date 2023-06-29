class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "b65fdcb4c2670121c48b47c26818e0e7af12ebdf69551298d131eee4d0212b7b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08cf26a0aaf97498b4c537ceaa2902aa00bc37c23cb52695f9e068bc9a62f5ee"
    sha256 cellar: :any,                 arm64_monterey: "a47805a38d3ce4707dfe18099324772ee89923ffa92565ef7199e29a4a34c7a4"
    sha256 cellar: :any,                 arm64_big_sur:  "c3c77d5b0b8d2567e79df0c89efe1b06848dcd4b0053587650147f5996cbf34a"
    sha256 cellar: :any,                 ventura:        "46b870b60b9cdeb574c144471a6b5f78b2db840a9855083488c0243b84f3cc79"
    sha256 cellar: :any,                 monterey:       "1fc15e025a02f70eac2684a0a5480ab8ba08ebfea7567a4eda266db516f1ba11"
    sha256 cellar: :any,                 big_sur:        "364ca4a7913449dd00680ee27ce5b67f8469e222d9b3f3591e06b5d4b17f483d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce8bb15a1afaf1d51117aa3957033418170d8759dbfdbde4acb315a609b087e"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./cargo-crev")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    system "cargo", "crev", "config", "dir"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-crev", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
