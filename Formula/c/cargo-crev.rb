class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "7ebc63b272f09730d44c469d39413e3208538e885cf977bf4a61d768948700a2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "27c18932097413d74558ad9d17c39d38c436142119937a65b9dd969733ad645a"
    sha256 cellar: :any,                 arm64_sonoma:   "d2d4f05d32b2f3f9c44819d3c8458d9c3944f6cb3cb07561083132168aa1141e"
    sha256 cellar: :any,                 arm64_ventura:  "ce177d1182cbdadd0368ecbadb8cb07306989185cf51343b0e082505ea259074"
    sha256 cellar: :any,                 arm64_monterey: "f1ea43a76e8e96b1ca044d07ccdf145a295c2f807f6794695bc28ce7eddbe246"
    sha256 cellar: :any,                 sonoma:         "aebc39346149c59f26c0f1773d8bb8976bc46a5d06f5a149ac2046aadc70ac29"
    sha256 cellar: :any,                 ventura:        "797528f2ad8e6006d82c9bfca61fccc09fb819efbda15bb096c82a867d9c5424"
    sha256 cellar: :any,                 monterey:       "807834bd912fd7190f78f4a6d7235b384e5acaebf308068626bc9e82fa896dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ac1a96b65b380dedb9d9696c784db1017427dbb3d181bb48292e8b8f71e9731"
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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
