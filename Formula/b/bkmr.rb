class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.2.tar.gz"
  sha256 "09b3f6db7675d2b036b22b9b1a4856b5ed5eead98fc9da781e5f780e2c1bd845"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3573e528ecdd67acce010304200e88910c748da4d57c26aca455a7499f8a416"
    sha256 cellar: :any,                 arm64_sequoia: "42678af503147c19c60dd07bdc9f7c67fc59e626cd06ecf3e47828f6c8420984"
    sha256 cellar: :any,                 arm64_sonoma:  "2580fb34a65550b98b536f367527b7015e50cd79b3af6e4d628962d0a11040ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "fca0bfbea683e90e2c0ea473743cae564c4e2f34c7f5348c237c5e40505c5766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720173b01baf907d07e7b989e403723edb2b256a8cf36c1324d6790aa4bb7f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b4661576651f6939460d5b99d6bc7ba404e2d4ce71053be55ba7f19944fbcb"
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
