class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_ventura:  "910fc9f942a2df4b3ee136e3dad43f462498789764fa35082dd61a0b332c194e"
    sha256 cellar: :any,                 arm64_monterey: "b0d030bc4cf06afa67b0e39034446133650ad6126896b4aec7cd4a7845a5e544"
    sha256 cellar: :any,                 arm64_big_sur:  "aa10fe12556adf1c9e9bd579c9da35b6c6589c03dd0ab7af2f836ce6a931a3a1"
    sha256 cellar: :any,                 ventura:        "e7da51aa740f180efb4ecba6eeafc94a5b49853034b2af5b6d7b0b62be01fbdc"
    sha256 cellar: :any,                 monterey:       "2e56e98a4a176368a16f374651607a16e75c7187576583b6125d59c03a0812ba"
    sha256 cellar: :any,                 big_sur:        "06319ab9ff978ac940f34b4ee8f8557da5971ab8048ffb34a997d18b9ffdf595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33403a5088316ff6339ea8674f8f5cc1a1f93d44e294cd0231ca559fcf7fc6de"
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
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")

    linkage_with_libgit2 = (bin/"exa").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
