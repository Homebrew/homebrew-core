class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.10.1.tar.gz"
  sha256 "ff0fa0bfc4edef8bdbbb3cabe6fdbd5481a71abbbcc2159f402dea515353ae7c"
  license "MIT"
  revision 1
  head "https://github.com/ogham/exa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_ventura:  "a3896eda34a5096be5642986d3de7c87eab719af5f6d3ad54ee216744a1462c2"
    sha256 cellar: :any,                 arm64_monterey: "1b10765192e4f4940862feab95cf7f7491f50fca87771550f4a0796ca0b7563f"
    sha256 cellar: :any,                 arm64_big_sur:  "29f335cc2130b0c5ee93236f9a3e805dc8af4fb9414a3e4b73d38e1c528399ad"
    sha256 cellar: :any,                 ventura:        "4cc39e72c301eef716e0ab8e2f05f91fa3e1cbf3545b8002f9602ceb2c3c3c82"
    sha256 cellar: :any,                 monterey:       "48e94b7764256f3e9e309dfd1a08c4dbaa2af3e2623fcfdb7c5ea9558fde6e5c"
    sha256 cellar: :any,                 big_sur:        "3668c3a6a375d1ef1d340abbb77488ea6c60a166ea692da3eda5eb04cfbdbef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a48a5beedeb00f98311e75e25cc3cd7043b1f9ef28ceccc5285bb4848eec34"
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
