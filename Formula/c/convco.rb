class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "8e5253e5968f364f86d2f1cfb24c95a68890bf620886c644c7df981b803bb808"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03f8bd556d6e1e6efb6a8aac33ccd0ca45a89f9e654c57eb88c2eea888a75046"
    sha256 cellar: :any,                 arm64_ventura:  "499362d8549e6af75ce8d5de9c19ef00e697ef98509bd915a1e27506c9c19959"
    sha256 cellar: :any,                 arm64_monterey: "9728b6d25e3802f369f8065e0e11047c99568c687996713dd3295b262d980b73"
    sha256 cellar: :any,                 sonoma:         "23a3641904c75d4cc837550888e462a1dc267ec72442ef20c3257ea555ff3909"
    sha256 cellar: :any,                 ventura:        "379c20a8ca3430d9ecd09fbade806215ccd2accf4a5bc90acf77bc5db8ae3622"
    sha256 cellar: :any,                 monterey:       "d490765dd9212c0ec3aa63d1be7e1282bc31e991a9fba1a043aaed7c2357d31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ab12a175a90de764e3ba2e95da151cd96ae54d413f16cdfdc47f15e0d64a25"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
