class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "1d1d275253567069b49d66abe65c04ae1fd5a5d3b8c173f57d7e1f696794c311"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f05204711d1a1ddd333ada91f7a43eedefd8fc6ae126b5f3e0e8fdb0087df12a"
    sha256 cellar: :any,                 arm64_ventura:  "8ce952b8bb74db3b6343485b08d42d68427f22e74288137f3015da6f6a4c9d37"
    sha256 cellar: :any,                 arm64_monterey: "cd38aca0fafcfbe648affb30bbac8d7ad5d7755f531efac8ac0329d014f81817"
    sha256 cellar: :any,                 sonoma:         "948e961998a7113217a7f529e71b82a39d1ad499619493e37c30a8439672ff53"
    sha256 cellar: :any,                 ventura:        "c0afc6c9216829e69176910eb2774e3c95c72fe5840949989bfb927afcda3177"
    sha256 cellar: :any,                 monterey:       "d0077e9ddef585429baea31535cbd28a9cf9ca585c6079d18ebd005da6b0e102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6ef0e53e7f5bcfb1365bfe8b11acc9e8d0e11b0c1c112e59a7cc1856daa40d"
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
