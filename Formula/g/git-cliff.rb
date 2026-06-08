class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://git-cliff.org/"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "3dd3138a009ade1085dd2f001f836c2bb406462a99512dbcb573bda1f2166274"
  license all_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40686a8475370320ad49bc0d7074391eb3d712f01cd7bc983966e067c6f168a8"
    sha256 cellar: :any,                 arm64_sequoia: "98fc49379e6a22872d3e1d205fd234780cb0b41ac4a66378716640f5d8eaf5a1"
    sha256 cellar: :any,                 arm64_sonoma:  "ab7309c8a0b92bda7304bbb34a3b101ad62de767536057b0c3ee425564973bc4"
    sha256 cellar: :any,                 sonoma:        "598622c959b88c2f79c918317cdacdd59b0f89d3a8c101f147a59ec6d033f3ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b61421e66c706df0df159bb2a081b3f2919173095cf1c4701c89d20102b80ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1df731ff0442836acb7f7cc8c5ff45a4a9567a8a6d8a9e7a710a97f2b2a474"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin/"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin/"git-cliff-completions", bin/"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_path_exists testpath/"cliff.toml"

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_equal <<~EOS, shell_output("git cliff")
      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-cliff", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
