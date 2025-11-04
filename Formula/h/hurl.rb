class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://github.com/Orange-OpenSource/hurl/archive/refs/tags/7.0.0.tar.gz"
  sha256 "3f505848aabd9eec78360928b0fcbfea237a049b5c8d25b8d9e0aeb3f9d8dfed"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08dd179f243a2f46255d613bc0b799b8f461fe13c11f3c5741ffe9e2e1c37a2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44dbde85cbbcad1e8aac88a7ea190fa2b0ca5898685350acd3d6ce138a94449d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85df68ff39fa518698dca50aef477aaed3f4b86a128fcf12e8bbd6d3661f1e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a204dda0fe775d61ebfe0771ad9113ddb0a256e90e1e367d4b02a746d16c01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135b3d0a2f49f086c1467670d9edad2dfa1364c7689fffadcb5b2f1ab0076c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87af7604443f3d0295a4dc3e63819ea38c1418bc2f7c4da7a7fcf7eb14c3ee3"
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
