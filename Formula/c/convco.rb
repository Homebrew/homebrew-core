class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "f89926784a8029bc179b0d7e6bbcdc899bce488ba97b55306bfec81599f73cb2"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "99b9f53dfb5ab750477d000a1a075f31679529e2237c5b4f0e9301fce424a9d6"
    sha256 cellar: :any,                 arm64_ventura:  "8f81761d0e28599c14bed48de60158a61a8df97dfa2a0aedb78a80826c4432ab"
    sha256 cellar: :any,                 arm64_monterey: "bd168aa3fee6924c16fd9597ac50491de2f989d56ebcbdab74077276ad6e02c7"
    sha256 cellar: :any,                 sonoma:         "f684c21eceb81dda556c62cda316a7c56647d6fef5ac62d59d0cbfbb8f3cdd7a"
    sha256 cellar: :any,                 ventura:        "c03783219c168c7c2f3099fefb08379983d476526234325d00c28886e8094ded"
    sha256 cellar: :any,                 monterey:       "188e0f576558ba2121eae6600e5deb921c07fb643e4a481ab2d2e1bbfbba8908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb39083abce38d692ee127f919f41345a735ace76ccee63fe39aa5bf15487df"
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
