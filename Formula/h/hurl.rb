class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/7.1.0.tar.gz"
  sha256 "1bbe1e9f2736209bc1c0ce3082d3debac08b1aec7c6203e0b6698669c8abc3f2"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd49915f44436cfadb09265f7a25bb416285ea1368b652e81e60cdd82084184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23cd51ed813f6a04ef2dda8bfe7835f4581db110e67b4aecccb4590652f7d1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086a925f840c851696f69affba51fdf048ef48b4bb9054357133422c074d162f"
    sha256 cellar: :any_skip_relocation, sonoma:        "66ed13f47fcc9f6edcdbfaadca45319b7fe411495491d5f3214cac72ccc78323"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3a50486dbdf525831cf6d4c3f28f9d9d29db10dd59d2a9362c1847e9dfc1f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc7886a550cb1fdb5331418be37e06e04f0b038ca0bc083d5385ffa65b17983b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "llvm" # for libclang

  def install
    # FIXME: This formula uses the `openssl-sys` crate on Linux but does not link with our OpenSSL.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"

    bash_completion.install "completions/hurl.bash" => "hurl"
    zsh_completion.install "completions/_hurl"
    fish_completion.install "completions/hurl.fish"
    bash_completion.install "completions/hurlfmt.bash" => "hurlfmt"
    zsh_completion.install "completions/_hurlfmt"
    fish_completion.install "completions/hurlfmt.fish"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    test_file = testpath/"test.hurl"
    test_file.write "GET https://hurl.dev"

    system bin/"hurl", "--color", test_file
    system bin/"hurlfmt", "--color", test_file
  end
end
