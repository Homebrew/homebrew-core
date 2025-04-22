class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "04b0be58900b31680d5c507885a51eb6a6f323abaafcbb8b9db0f372704c188d"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "004a450d0b404fac8937520eaf92334618b50a597a5d3f9e9d98351ab7e30921"
    sha256 cellar: :any,                 arm64_sonoma:  "f56109efbc8eac9fdb331ead6704a0b50fee6d60ea86d0055ce6d3a1990e1f51"
    sha256 cellar: :any,                 arm64_ventura: "ee3921f1b27d676f3738a46094f761f250d4e10a60cb2fe1e2b591818c25ec17"
    sha256 cellar: :any,                 sonoma:        "058b61261d0167416a24706618685d376c5d79fac365ca363679fbf92373a78d"
    sha256 cellar: :any,                 ventura:       "697b9e53ea58c1bf59e207b66c73e038bcc1860aee1f5aa62d9441816a356698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d3c4a71a006775cb959b082af29e3847b568be3e56b397cef97d2a9d8dc7b3"
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
