class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "5f25e866521c310d9530b9bbabeb288ad8d9cd208adee79582dde79bdd51c470"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "232de45b149daffb875042620d5f7dc0a54506a43ceefe0a2a2f09f23c461964"
    sha256 cellar: :any,                 arm64_sonoma:  "6425625b3a0a2b39dbf3c9d3a836f94fbbae12d5db9b8ca964affd99f6f91c5f"
    sha256 cellar: :any,                 arm64_ventura: "e63b3bac10c6832674267c11c27adac719ef114d24e7c85c77ef1f42a4d1acbf"
    sha256 cellar: :any,                 sonoma:        "10e410c268ff6f3b8e07b3f3be208a9db6b63e2554f6ef1e6042d91b7e71dd85"
    sha256 cellar: :any,                 ventura:       "3e7a638d9863000e5d2409e6cb1a74eec71f58f9d7bdab6af6dccfe02c373a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a3676c7006bbfdb9576df6b5917f59293d85fc13710f0b8f3074e2f43254ed6"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/eza"
    fish_completion.install "completions/fish/eza.fish"
    zsh_completion.install  "completions/zsh/_eza"

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "man/eza.1.md", "-o", "eza.1"
    system "pandoc", *args, "man/eza_colors.5.md", "-o", "eza_colors.5"
    system "pandoc", *args, "man/eza_colors-explanation.5.md", "-o", "eza_colors-explanation.5"

    man1.install buildpath.glob("*.1")
    man5.install buildpath.glob("*.5")
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"eza")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    eza_output = proc { shell_output("#{bin}/eza #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", eza_output.call
    system "git", "add", testfile
    assert_equal "N-", eza_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", eza_output.call

    linkage_with_libgit2 = (bin/"eza").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
