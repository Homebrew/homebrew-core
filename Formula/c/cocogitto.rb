class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/7.0.0.tar.gz"
  sha256 "cc00dacf1dd12b63976b0ca3c4ec383f902a95ed148968ccd35d9a174f66966f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88ff662284f7f242372e75430dacd7eafcfc26918e61981abfd74de963c9b34e"
    sha256 cellar: :any,                 arm64_sequoia: "69d6b4328b431c98df2b7f2f9e654c1f1ebd83d5d455eecca43d1865ef2f53a2"
    sha256 cellar: :any,                 arm64_sonoma:  "91910dbc605d51048db6dd512e894735d4d56781ca4224c9ba428fb580f588f2"
    sha256 cellar: :any,                 sonoma:        "e3aa13b9c500755886f8cef11eb5d4b68d01d3d60d237a3a2cd1d73978f4923a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c28d53145ad804f7f71bc5140425a21d31b0093fbf3318a64aa378f3220e5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3404ea70767d5d51bd225b30da32e17fbf6c45df751731360c76610027ad7268"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cogapp", "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/cocogitto")
    generate_completions_from_executable(bin/"cog", "generate-completions")

    system bin/"cog", "generate-manpages", buildpath
    man1.install Dir["*.1"]
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init", "--initial-branch=main"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"cog", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
