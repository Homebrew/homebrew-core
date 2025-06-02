class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "dbe04448febef15b144e86551db633146864f4afb272f96c4d586e0bc8284ffb"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cde99ea220d3447d975c3a87333156c97631cb196772c6805d1b4442f9eddcc9"
    sha256 cellar: :any,                 arm64_sonoma:  "f51d4301fcaaff8c1a9d3c15ee35fc9623cff9ec6fac4e0fd359178640f71a0b"
    sha256 cellar: :any,                 arm64_ventura: "d638b9bb8eb143bc16f8ede4456777bdc31a70ddbf7c50e9b387a9d2bfc78f75"
    sha256 cellar: :any,                 sonoma:        "efc2fa25806fa2338a7ced9e9a4cc7e0d37360f1a15e846a514355a3e345c3d8"
    sha256 cellar: :any,                 ventura:       "8f9f142d97468ee7f3e24401fd89ae437dc38d4eecbd06d30f41509c76804f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc082bca9b783112876c08d3f07881909c47cb60dff4774941131e4246037925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9c85d3b74aa56e285ab0d2475dc5c8c6bf2322ab7cb9aa064754a37d763504"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
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
