class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.5.tar.gz"
  sha256 "04bff12e46817ff96b0ff3ad7f20d93e13cb767e9ca59e57e095f7e9dcd8cefc"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab13615293e5e19662ab0f330331c84bf7e69c43bee3dc71df20c993175ceaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a620c77af7bf6c8a845572ad7dc62c1c880c41feab7b494db2ffcae26f871d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f347c2007b393cf2b0fb7a18e617faaae52a7a4637d0c13132bfd2320f9df3ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc53738995bef98455f107fef191d162ae2b0a897411a2399e99f5be1a72c97"
    sha256 cellar: :any,                 arm64_linux:   "6b9fc6b5cc6996d0cc6afa3b373486c2e4c7044dd06f1a5b864ca098258f4bb3"
    sha256 cellar: :any,                 x86_64_linux:  "62223f17b208536a855368a53d09d46641a0b73186d986a1f22cf28db2c3f856"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    # Add Homebrew lib to rpath so dlopen("libonnxruntime.dylib") finds it at runtime
    ENV.append_to_rustflags "-C link-args=-Wl,-rpath,#{rpath(target: formula_opt_lib("onnxruntime"))}"

    cd "bkmr" do
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: "system-ort")
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
