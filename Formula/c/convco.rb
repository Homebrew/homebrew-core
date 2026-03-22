class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ea178bb268e45d507fd358e391fd6bbb552b8d9f6801f0193b4422e172fc6917"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d02ab94f2d6e468fee2255a72771a89f545c0869e5d0021350c93b8b17f27c0"
    sha256 cellar: :any,                 arm64_sequoia: "602743c1056d2e6d46eabeba444d0050a6743bcf4076551080e1b348c869faa5"
    sha256 cellar: :any,                 arm64_sonoma:  "fba023ca348a3ddef9647129f25ee79ea2db78fc1e8b9cfc5af146cca67c9667"
    sha256 cellar: :any,                 sonoma:        "18aad1e5093825a344db20f15e992b149ec3948828008ec673069ae0074a9bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f48b217348b2f0ff2118a4cbd0f87d2574d6986fc700266910048655a09fd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ddde9364a84fcd9acbbb88c1537560d7b01795bd4c9dc7ae6f6ffa6a608a259"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"convco", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
