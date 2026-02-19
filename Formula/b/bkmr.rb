class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "4ec864f2678ff9eb48e612e9ce18d832b8bed969524d27169211f3484d064e7c"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3019ba82f2e7eeeba3022fc84340a2d6ac8bf4b941fa6662c8a3093f9ff4c893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82a8f8df23af13a5879b3c89fec219cd7291d6b7fc15f25390007e209d75fc6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627eb4a376fd470d09c0cc8c492356862da5b713f034f9dca782a6b17ad3c71d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a729c19ae6857d6a5e09332ed840596c4f21b82daa3fa2d09aea0a2db87b681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f361d376fef207fb43ce3885dbafa3bf166c0c7a875073a98f4ea8540eba7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e0d32604a5acb5ef19805b65f670bc49de8b443019164a16cb11c46124c364"
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
