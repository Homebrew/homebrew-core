class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.3.tar.gz"
  sha256 "73fa7f4d1e17d4f8c131c2892c29e4c5018145b67fa3ef13ff5bf2f9cddd2a0b"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4384a67fdc85dd994fac70de453a9fab630a8239325ece7cc3ad167573e0504b"
    sha256 cellar: :any,                 arm64_sequoia: "c22e9c140ebaf049fef42370de5d10e77dafa5d43bc522c90a34b0c2fdb495de"
    sha256 cellar: :any,                 arm64_sonoma:  "ab5f91220f9eb2bba4ee2d4ca1c800dc25736598a9c5d677ed7558fb674ef842"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3ae8222ca733f7ff7fb6123063794f767c7f006be1fdd0381752bc7c370209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba22106d07b7b4bf55dd126c7589f0473c0960197803830b71803103f96169eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "031bee7405dc34743e15e57ef676aca68ef02118a7c72ced10da63d10e284e42"
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
