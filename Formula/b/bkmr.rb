class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "074bc7e4ce20c0e1fcfec41eb5f1ac0687cee762ff952b3ed524a17fc92b0174"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5839233c8bf049bed7c316b0d8102274bd0731179a36608f7d71aaee83b1e128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a65832f70d1a5fc007d13b0ec8e08e41676e023a16ae93cfffdc58cea5cb00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1565be26645a68f285ea8e649ce484e01eda17baef9fe58aaff1b67bf496c1be"
    sha256 cellar: :any_skip_relocation, sonoma:        "830f535f9fc7f2372ebe907bc662b4d0dae498c472e99b0b98db35c686e90f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abdb8e51604cb4176af23bf3dbd6a440a027255ad696a9ea6e9f86c3547fa919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "861a84d444b5c355b2129d65d8ea25f7c195685d6e4f5569fd277130938877f3"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
