class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "6f8e58f8572a785e32d287cad80d174303a5db5abc4ce0cf50022e05125549dd"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6b41d26f7fb4fbccc99373e356bd899e89d0e41f568c07182d5b1e5b2a18fdf"
    sha256 cellar: :any,                 arm64_sequoia: "e1c093220b014473d3a149c15ae6b832e5bd00a29f53e4536e7e61c5f5d23fc7"
    sha256 cellar: :any,                 arm64_sonoma:  "8735477bfe61112d9b04356962c578a92ce2b446cb05086932e9ef8d2c452a28"
    sha256 cellar: :any,                 arm64_ventura: "e66f77d70c4c03b8a9057b0bb1625bc299a53f6ff009df8360a337ec1295cc76"
    sha256 cellar: :any,                 sonoma:        "e43a535594de8583f7313f689d34110c44d8470848187d3996f1c3ec1ff91d0f"
    sha256 cellar: :any,                 ventura:       "cb1e5727f7cfee8c3a2c83e916cf870a99ee440d238727cc3d89c8d062eedc69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a970e8d83d06d8484d388e474354b61c547792c1e27ed72ad2f8eb0d6008b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889fe4c5139b8dd815723ed30fad7566fdee06967247cfae99bf5604ec394991"
  end

  depends_on "pkgconf" => :build
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
    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"convco", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
