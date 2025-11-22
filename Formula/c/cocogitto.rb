class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://docs.cocogitto.io/"
  url "https://github.com/cocogitto/cocogitto/archive/refs/tags/6.5.0.tar.gz"
  sha256 "b807f6201dcbebbd97e0e8e34d8f2f14885b1b1c529b465463fe7a4dc8209ff5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a704fbe771aa230e5f98656e922a01efe4312a6e33dbfb78bbb04ee87a06463c"
    sha256 cellar: :any,                 arm64_sequoia: "36bbcd4bfb64967dca2190df496432a21ba77d3883b25200ca631ec94b3371a3"
    sha256 cellar: :any,                 arm64_sonoma:  "c02747e437f09dfcb70359ad8e859c86e5fd4c01d41f1cd1ec0ae6ca6bdefd10"
    sha256 cellar: :any,                 sonoma:        "b6563dc90f933912cabfcb22ea6260e97d6fe610c5ea679c0a0e98fed2d2fff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c71d19c76a15b2cd48561419e940279ede41de5bf7236dcf99cf977db39a363e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740669b61556b1b7213dd4037ad17e6e36bd5ea9f5b2130a6154ccc0f43066ce"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  conflicts_with "cog", because: "both install `cog` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
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
