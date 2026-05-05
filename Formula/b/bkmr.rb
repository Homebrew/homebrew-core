class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.2.tar.gz"
  sha256 "09b3f6db7675d2b036b22b9b1a4856b5ed5eead98fc9da781e5f780e2c1bd845"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0605f0008e996454fa355ac05e9c96cb5d53d117363672c50d966d7c08a0336"
    sha256 cellar: :any,                 arm64_sequoia: "8158d063e199e9ef465c8310ccd6f894b3f6dc05a0ff927b072d2a71525713b9"
    sha256 cellar: :any,                 arm64_sonoma:  "a84faf363872d3298b6eae41b95bc04e28afaea83a84720e74e7a002f37c2057"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d5dbf749c9cb1fb5db2fee2f5d74620789758ddf0ede9541cf83d519fbf2b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a547f574487d9e1e9a3d9303b1cdb1b3261394a8332621575b9dd1eec7302d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9679584a7bec6f6c8ef16925ab27465c04db5e5a8cb576eae86433d66933dec"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@4"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix

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
