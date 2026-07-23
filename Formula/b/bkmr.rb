class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.7.tar.gz"
  sha256 "773b19c49f7ee13a9323edc300aa8b1ecb6f429f4f98f7f120d0c5531b73da66"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f9a3b9fc0c1b17d582d381e76ed1d7e395af9a4fbdcdb77157da2450636db62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f40fc58770c00c60e2c34e50451d3567b8fe2231c0f8776fd1fb63ec4c85f73e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63c2c07a301420e692c15d408733842a9beb96166b882da7d2aebde24824f068"
    sha256 cellar: :any_skip_relocation, sonoma:        "747f30c7f34c15f89cce9c874dc8e6671600b91d1d2adb773e15be5aaf6e52c2"
    sha256 cellar: :any,                 arm64_linux:   "470378694fd8a7bcd46a617170ecb0d02d9033f1165adcfe5137d1ccab6f539e"
    sha256 cellar: :any,                 x86_64_linux:  "9698712147c009da5ec5f8c2a0f30821c6b5a3df91857db2bc19928e131da676"
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
