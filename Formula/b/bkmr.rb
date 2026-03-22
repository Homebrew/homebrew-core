class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "c8f8f60f231cb94d7261d4a6f6c9fb06e7900e04c8b8fde0e95716c0dd46fe04"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c095ef7e09ee0d4cac424e23d2dead2b96021e74a0477126b55c425b346bc73f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4a923753218fb1787185a527332bb7ed8558487af23d978681e0df5900a9b1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68ecea4c58a5a71e9ff80c718f15b03135bf0af3415b10f601cecaea8c009698"
    sha256 cellar: :any_skip_relocation, sonoma:        "500682ce24d9f4a34eaeb4cb2c1acdc2082de29172447f280f2ac6b722c8f15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fa6abec6b827a65ac6a67f3efa354d18786c3f234c699c18b2ddafee8d6c353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11e2d4055b5308c72da612cc7ae82c0ce124bd10e5058883bad56a9cbec265e"
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
