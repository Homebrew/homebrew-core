class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v4.28.5.tar.gz"
  sha256 "515f00bd9895a9dc1222f59b2f41f8f68290f2f03c73cf207ba783a870f44a84"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7e12266ddbf834d7ac32d060348606176880bcef075a3f121b16fb7b21d8cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6543c62678cab9dd0787ed14e32ffc06964c1565389fc1ebd7b3f9b61ad02e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79b7240540f8c21a43068e9a4f13f78d172a2823d78a4f2e0e1a03b80ce0f0c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb86a634164793d6ccfa5da2bbf5632d0f07fd1f118fe4ae8bbeaeb272a913b"
    sha256 cellar: :any_skip_relocation, ventura:       "fc2c950e48636c476c1398bcfac23fbafde98ab6ddd88b51e7d9dd4bbcd26ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12fd3e79db46d9afed087812052f09c0273c0b055604af9a017dda220b538e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e62c94a52ae11d6bccc4c46f6342ad5f8e1f85b462960ff1cb201c6d3ee32b"
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

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
