class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  revision 2
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6ffddb1955d59bd6bec1eef0ca215beaa97f21ed1c79f787ad9bc9d62a917fd"
    sha256 cellar: :any,                 arm64_monterey: "c45e4ab5bca902c1a1c404586048915a88b75485760c4b01569818e344a871ac"
    sha256 cellar: :any,                 arm64_big_sur:  "8f42c8fb57379c0f79ad43d226aa4982ee4a64196052db03b9b758530b5bdc27"
    sha256 cellar: :any,                 ventura:        "c9df09eff6bd471405a0fcdf387e9f3a24bfae28e9cf1493578ae7232322ab33"
    sha256 cellar: :any,                 monterey:       "dd7d5ae25d2db208f28b52d1166a1ebaafc5f2dbcc255fda4b4154c58eae1c88"
    sha256 cellar: :any,                 big_sur:        "ef0c0717451182f796a0725b849cc22f2d647c547d2fdbeb68974d9e3336e0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f246ae588fc60262256922e351c4d6df6bac9bc5bd475accf33103912288518"
  end

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
