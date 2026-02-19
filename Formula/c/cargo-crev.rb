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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "81b2fa2f7315f2665d8dcccb6752d37b56652bd7ef02c18129a8f5a406277c43"
    sha256 cellar: :any,                 arm64_sequoia: "493e9ff59968ff20604d88efd36caa673c6111ed908ceef6d25e2c7a9a430c6b"
    sha256 cellar: :any,                 arm64_sonoma:  "cf4941e37d2916c721d3c7fe7acf882fd025f131f7a31a57ae60ae04ce968957"
    sha256 cellar: :any,                 sonoma:        "205486c193ca878625a1c5e2eecc5105ef46239be6057814f5e423da7ab73d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307f024d7d29778e3341fe7e2a39864d0cf546bd1965f4b3cea1b4bc8cefec7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "616a84800440e0d72026f04b52adbc1dd7c2768cba516fb3517f1e98658ba50c"
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
