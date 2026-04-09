class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "ff94196f04dac1e15fd9a1882a4f28a06a39295cf85a69e47d9d596193da11cc"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "981398303bfcdf1d0ac8632ec2aab00c1daa90ad6a81ae9ec9320b06e742ac57"
    sha256 cellar: :any,                 arm64_sequoia: "49a69d94d72a10b1bde5c8a27b4b927a12a8e7f5c7408bc3c70137175aa0c80a"
    sha256 cellar: :any,                 arm64_sonoma:  "ab6205d1ab4f743fba53ae69d9b3ce50a1e0e5593d88cf87cc46dc48c24fa587"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e218569eed5c4dd2c146fed42d5da2c1296c71e4d60b998418d8f201d21ae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d506cd6750d23ff81f5944a62550fa01e8c9853e27689c101fe2bd6837dfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b867ddb8333a7bc686f6a8435858d6aaab97dba7dc50c98bd010e577444a6ec2"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
      ENV.append "RUSTFLAGS", "-C link-args=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

      system "cargo", "install", *std_cargo_args(features: "system-ort"),
             "--no-default-features"
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
