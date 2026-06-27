class Echtvar < Formula
  desc "Rapid variant annotation and filtering"
  homepage "https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkac931/6775383"
  url "https://github.com/brentp/echtvar/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e4d04d16d9c8e02aa9c216d7c7173e4d35ed3a9f848d05e5908d60e74b5c128b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "967774e36783e194a74363623e9a0b9cdfd45aabfc65f733d2c96d9b9b6fda47"
    sha256 cellar: :any,                 arm64_sequoia: "4070e9a38ac9d8f75cfa5cbb740b248998b6d3f42033de8597f8b8fba3624e9f"
    sha256 cellar: :any,                 arm64_sonoma:  "7ab19da28e45af8d314ccd2bf7ad7adc61a875ea633673f8354925bc10dc327d"
    sha256 cellar: :any,                 sonoma:        "cab470a71b38c30e926f6fd91cf7ffee9607434936abd12f230f922f8aa7a387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fccf79a988ad5faa9d5d81178597dcda3793373f30bdafa4554d702a5f85477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "911a3b77a4afd48105d6a398fd58da0709880cb409d712d68a0e552286ec137b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14" => :test
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # portable_simd feature requires nightly.
    # Use a stable-Rust stub to keep the CLI buildable without nightly.
    ENV["RUSTC_BOOTSTRAP"] = "1"

    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp_r pkgshare/"tests/.", testpath
    system "python3.14", "make-vcf.py", "2"
    system bin/"echtvar", "encode", "test.zip", "test0.hjson", "generated-subset0.vcf"
    assert_path_exists "test.zip"
  end
end
