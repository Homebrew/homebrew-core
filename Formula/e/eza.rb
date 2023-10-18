class Eza < Formula
  desc "Modern, maintained replacement for ls"
  homepage "https://github.com/eza-community/eza"
  url "https://github.com/eza-community/eza/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "155d6e38a37c9d2fd32d2234662dba2e0f50b553826dfff290ae8f7c16dbb389"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8a22dff95688ca419698f87008730acf663e77f558367c55dad45ef47a87ffa"
    sha256 cellar: :any,                 arm64_ventura:  "681aa7ba79d32bdd46e362529ff94ab5e15e3dbb11aa0e35d7d228786ca63341"
    sha256 cellar: :any,                 arm64_monterey: "faf54e228bcdb87f3b240419f3efa27b7615ad13aba34334e1624a9a05061521"
    sha256 cellar: :any,                 sonoma:         "f14177a7ac7828d8c8db7a9ebbeffd5cdec7668703b1e37c1067ce4f1753a7e6"
    sha256 cellar: :any,                 ventura:        "cec457e5353b1da8ff35855e10fe2e229bdadbf21d6e42dd2fe4e8aa16395fbd"
    sha256 cellar: :any,                 monterey:       "4592893175a9363e552041cf9b3c03eb232a67363fa0eb122712b43acb04470a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5bdfeee8dc2f0be7d2773939d592677120085a07076c2e7be77642272916d9d"
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
