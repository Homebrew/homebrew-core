class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "0fccd2751568715d708106a23b570201298c2347a360afc522d7029b432f5206"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "677cdad94e11c28e9cc57f3cb9e458a8eca2b4d9f6c486cbd45f50630389c843"
    sha256 cellar: :any,                 arm64_ventura:  "6135e148123c611a17d57d1292e2a122f9ec828e8276d5bed4cf6684a2a8b852"
    sha256 cellar: :any,                 arm64_monterey: "b3dc648ed3bc10fdf8f371ad1270c31b9859cb73f2a4db1ccee37ee476387fe8"
    sha256 cellar: :any,                 sonoma:         "b2af05235d5101b2eb11325886ae881af45b4f7588fcfe60d8375a6c8a365160"
    sha256 cellar: :any,                 ventura:        "2a3d7e2fc9910cda90635aa7267d7efa506596d756f43ec543be3074f6b7fc16"
    sha256 cellar: :any,                 monterey:       "37b5e4c6ad7aa899af9b590100341daa638bb93c7f05fe8296eca6f6e45a6ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aaaee2954c7d33cceb4f7715d962d11ca96f517cd38e2b103f67b1085a73433"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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
