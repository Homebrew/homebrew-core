class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "917736591429813ef4cfce47bb2d3d87e9f1e142b2a6ebf74a345c3a15894918"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5ca0cd4cf2c860b2683e31c84a4edb32d14b40ca21288fb81dba3d41545a6e3"
    sha256 cellar: :any,                 arm64_ventura:  "db3222f47eb4be840c7fedc2e399b4b6ee4e7696261498ff40756e611906dfd3"
    sha256 cellar: :any,                 arm64_monterey: "59c6cf88acc6b57615edcfc5b1182da00b0a3be22db176219d1791056f656b6b"
    sha256 cellar: :any,                 sonoma:         "d1dbe8e5a738fde2157e0091c2d720173917925d20a5a6a07a1feaf9bbdfdcdc"
    sha256 cellar: :any,                 ventura:        "6d437afe97dcedef1b8b8080b8cb978f9a15bf0b07319fa15a24e15ee70d1788"
    sha256 cellar: :any,                 monterey:       "c0fd8089adc7d1629eac569e7d9a46e585217d08496df992fbd4b849c8c170e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f645f3ea427a3cb7241d679be335ca4e18a23a6bbfcc7c7812a725ac80cdc3a"
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
