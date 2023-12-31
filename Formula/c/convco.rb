class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "abc859df764c6dbfd3ccc4b21278e703dda88e7bb454943d8606985fa3d105b6"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "56de23fb169c60a2ba0f0c66713343278506968b8ef2676c3701c3c47088d912"
    sha256 cellar: :any,                 arm64_ventura:  "46eacc644260c3840b299c480f3e301dc40fdbb1bd6da201cf121a18450aed8f"
    sha256 cellar: :any,                 arm64_monterey: "135bfbf4a5f02f7d554258fa0cf6efec0e3cda0150f529263862185464da382a"
    sha256 cellar: :any,                 sonoma:         "f9bf641a9585ebae8427f15d9a1c62ce61b0b66fa778653abbe817a8c3083fb6"
    sha256 cellar: :any,                 ventura:        "2558d3ce7eb2db5cdad9b7f707f5bbd7153ccab046325a7708ebcb9e8aac0c4f"
    sha256 cellar: :any,                 monterey:       "e5fa13be93decc4abd7bfaacd3e12f144514599047754b4633c95ca0538cdc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bf986d24d8bf34d2cd8b7446f9d87da22ff32355fb3043fcac7a5a2132a2479"
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
