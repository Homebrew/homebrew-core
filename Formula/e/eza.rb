class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.20.7.tar.gz"
  sha256 "981af52e7a0d5ab374ed2a58b0bb9542acc81235ff479bb1f08d61941f65b18b"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c19125e08ab074e19324bc740a7eb8721e9b14524f2c734e5e4d3be7771c039"
    sha256 cellar: :any,                 arm64_sonoma:  "542e953643c7f7971cad71639f56dc7634948be3860533e582dc009efd1dee62"
    sha256 cellar: :any,                 arm64_ventura: "6140c9f81866efbbda9c6b3f752d412111ed42a0f5d499118088824604bd1a79"
    sha256 cellar: :any,                 sonoma:        "04557fc2d5c3d573c9db8643b49dff37aa0d56cea4eb61fd49eff30f11d05a85"
    sha256 cellar: :any,                 ventura:       "52ddcf2f18f3cd508bdf4567c356c78cc3ad864d558291f9b6703ef9f9e4be2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "360312af714c6250c9ae7f5ac6f152e07c025c39965b4db8cbb7503fe664bdac"
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
