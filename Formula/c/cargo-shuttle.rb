class CargoShuttle < Formula
  desc "Build & ship backends without writing any infrastructure files"
  homepage "https://shuttle.dev"
  url "https://github.com/shuttle-hq/shuttle/archive/refs/tags/v0.57.1.tar.gz"
  sha256 "3f17e62f6a2526e3ce4be9bd1b35329bebbf5e4ab32c4c51831e2ec999ca8943"
  license "Apache-2.0"
  head "https://github.com/shuttle-hq/shuttle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd6e06098fcfe70f338b6eaf9ead44976d090d18b05fdb374f51c47a8ed5a156"
    sha256 cellar: :any,                 arm64_sequoia: "87db38e27c724b005f4141c6e21aa96c2a81dc1cc6205538cef165077d8eb064"
    sha256 cellar: :any,                 arm64_sonoma:  "cfb1dd6ea4c8a01a0a6ae8f138b92748425e91cf8b9ed728372178c86b2f359e"
    sha256 cellar: :any,                 arm64_ventura: "c71f0e0c163602644d6a191fa4eb1d66f6bc35368f14c02843dbe71e9f29f568"
    sha256 cellar: :any,                 sonoma:        "833ced092a8d3b51a471cba9258e180b02af7f36c20c61c5e4eb1d6ec5cb3e76"
    sha256 cellar: :any,                 ventura:       "1b242148ab4ab19c3c5bd91bd613a20fbc8fc8e76b026687ab083a71e0fb8383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c4e8085f0b60a58bf01120fa9f022f24f954b12605b6c9c77b3a19183b97a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1c235efc953f5827f701efe06e8fda14a1236d3c78846e24a50c34e3ffe02a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "bzip2"

  conflicts_with "shuttle-cli", because: "both install `shuttle` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "cargo-shuttle")

    # cargo-shuttle is for old platform, while shuttle is for new platform
    # see discussion in https://github.com/shuttle-hq/shuttle/pull/1878/#issuecomment-2557487417
    %w[shuttle cargo-shuttle].each do |bin_name|
      generate_completions_from_executable(bin/bin_name, "generate", "shell")
      (man1/"#{bin_name}.1").write Utils.safe_popen_read(bin/bin_name, "generate", "manpage")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle --version")
    assert_match "Unauthorized", shell_output("#{bin}/shuttle account 2>&1", 1)
    output = shell_output("#{bin}/shuttle deployment status 2>&1", 1)
    assert_match "Failed to find a Rust project", output
  end
end
