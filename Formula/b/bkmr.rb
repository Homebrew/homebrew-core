class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.1.tar.gz"
  sha256 "d7c348b5462a6052ff1fcdeaaecbf862033b06506592179b1b1e8ac260783a2e"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6abcca5b8e9df1e2c48adf266b7e9d94f000e3ae2bd29690b729db2bb23d0feb"
    sha256 cellar: :any,                 arm64_sequoia: "ef5545bc9307b33bf5bd9da044bdeb5af21e0eaa20fb0740d268bc70e83d3489"
    sha256 cellar: :any,                 arm64_sonoma:  "09eaf4b4921c55942abb4e1812f851aafd36da9a2c8067cf82c625924176f4ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "459fc69e957329b04fe6422f6416d805b52bbad1d534d701e891928fddc3c5fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ecf3865e4bfc91771b03303c10e3a7f07e3b04d7fcfd64f8c4b891bcb51326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e174aac93ac157a4611a39d76db4237dd85acbce0e4a23f9774fa088f7e1881"
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
