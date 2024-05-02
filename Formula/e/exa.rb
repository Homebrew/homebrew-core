class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  revision 2
  head "https://github.com/ogham/exa.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d99ebf95ff1080b152f3ea15631987f6203cbffb9766f5585cf3ca5695626936"
    sha256 cellar: :any,                 arm64_ventura:  "1fbc96b6cc8e79125e95d083250528237b558c80e84b658f1936d933d64d1b50"
    sha256 cellar: :any,                 arm64_monterey: "eeeb2902af9bf5465d036b8fdab6288d5764d0d9b940e88de54bc196b39f699b"
    sha256 cellar: :any,                 arm64_big_sur:  "bc4619504bbc74c4372db9708b683821f81da86fa9a105d29120557ef5366bdb"
    sha256 cellar: :any,                 sonoma:         "38b5085d73558d8a088a8052dc9b4a49ffa8b477ca250fdc8ec344042d2b9ae3"
    sha256 cellar: :any,                 ventura:        "d6737d9f4980f0e085314e3494ebc03ac433baf1fffd936faac33e0a2af7c5c6"
    sha256 cellar: :any,                 monterey:       "fe91256952b78220dfe0f26c7b73e81533d0d2c1bc9440383c4db39be0581cd9"
    sha256 cellar: :any,                 big_sur:        "0e311b4464335682e78e141bebf3d44b4428aa4a96c2b49c354b6d0cfbe4a24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d05214f3c9390661f6b3357c3053fbab35f547a31a1a4e6cb9e8340dc655eb1"
  end

  # https://github.com/ogham/exa/commit/fb05c421ae98e076989eb6e8b1bcf42c07c1d0fe
  disable! date: "2024-01-24", because: :unmaintained

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args

    if build.head?
      bash_completion.install "completions/bash/exa"
      zsh_completion.install  "completions/zsh/_exa"
      fish_completion.install "completions/fish/exa.fish"
    else
      # Remove after >0.10.1 build
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"
    end

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
    system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"
    man1.install "exa.1"
    man5.install "exa_colors.5"
  end

  test do
    testfile = "test.txt"
    touch testfile
    assert_match testfile, shell_output(bin/"exa")

    # Test git integration
    flags = "--long --git --no-permissions --no-filesize --no-user --no-time --color=never"
    exa_output = proc { shell_output("#{bin}/exa #{flags}").lines.grep(/#{testfile}/).first.split.first }
    system "git", "init"
    assert_equal "-N", exa_output.call
    system "git", "add", testfile
    assert_equal "N-", exa_output.call
    system "git", "commit", "-m", "Initial commit"
    assert_equal "--", exa_output.call

    linkage_with_libgit2 = (bin/"exa").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
