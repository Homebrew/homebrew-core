class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "1a158f346c3308bad51d8ab731122f6d2e716499fe004a695d195a93b7924f43"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a46e2f3171e258f7d79f5cd8a43bb0f2df0fae4b37a898996c68f95407020ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a8264d15ea0041568f7f0366f70a2aec6a061ccd59442d6974fed6045e6f12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2042d459082422fcea6eb00f8c8f7b64be50fb1e94c42bbd496649df65ffb1f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c47f48870344c7e4c8d91d6cc865f0c607fdc7a3a6f585e0661a4dde0d6dca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d97879e99f8a9f9330f168ab7886b6b6dab471c706ac0d810ae42b2aef3433db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb9fedac7bbb991f87c2a3c5c89fc71457dbd39f08b811224d50fdfd3092e06"
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
